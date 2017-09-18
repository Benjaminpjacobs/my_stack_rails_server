document.addEventListener('DOMContentLoaded', () => {
    const BACKEND_URI = document.querySelector('#app-messages').dataset.url;
    const SOCKET_URI = document.querySelector('#app-messages').dataset.socket;
    const GITHUB_IMG = document.querySelector('#app-messages').dataset.ghimage;
    const SLACK_IMG = document.querySelector('#app-messages').dataset.slackimage;
    const GMAIL_IMG = document.querySelector('#app-messages').dataset.gmail;
    const user = document.querySelector('#app-messages').dataset.id;

    const EventHub = new Vue({});

    const GmailEvent = {
        name: 'GmailEvent',
        props: {
            message: {
                type: Object,
                required: true,
            },
            markAsComplete: {
                type: Function,
                required: true,
            },

        },
        data() {
            return {
                show: false,
                clearAll: false,
                fullMessage: false,
            }
        },
        computed: {
            messageBody: function() {
                if (this.fullMessage) {
                    return this.message.data
                } else {
                    return this.message.snippet
                }
            },
            messageButton: function() {
                if (this.fullMessage) {
                    return 'Less'
                } else {
                    return 'More'
                }
            },
        },
        methods: {
            flipShow() {
                this.show = !this.show
            },
            removeMessage(id) {
                this.flipShow();
                this.markAsComplete(id);
            },
            showFullMessage() {
                this.fullMessage = !this.fullMessage
            },
        },
        created() {
            this.flipShow()
            EventHub.$on('clear-stack', function() {
                this.flipShow
            })
        },
        template: `
            <transition name="bounce">
              <div class='message' v-if="show" >   
                  <div class='message-contents'>
                  <div>
                    <h3>{{ message.event_type }}</h3> 
                    <p> Subject: {{ message.subject }} </p>
                    <p> From: {{ message.email_address}} </p>
                    <p class='email-body'> Message: {{ messageBody }} </p>
                    </div>
                    <div>
                    <button @click="removeMessage(message.id)">Completed</button>
                    <a href="https://www.gmail.com" target='blank' title='open gmail'><button tabindex='-1'>Gmail</button></a>
                    <button @click="showFullMessage">{{messageButton}}</button>
                    </div>
                  </div>
                  <img src=${GMAIL_IMG}>
              </div>
            </transition>
        `
    }

    const SlackEvent = {
        name: 'SlackEvent',
        props: {
            message: {
                type: Object,
                required: true,
            },
            markAsComplete: {
                type: Function,
                required: true,
            }
        },
        data() {
            return {
                show: false,
                clearAll: false,
            }
        },
        computed: {
            clearStack: (id) =>
                this.removeMessage(id)
        },
        methods: {
            flipShow() {
                this.show = !this.show
            },
            removeMessage(id) {
                this.flipShow();
                this.markAsComplete(id);
            },
        },
        created() {
            this.flipShow()
            EventHub.$on('clear-stack', function() {
                this.show = !this.show
            })
        },
        template: `
              <transition name="bounce">
                <div class='message' v-if="show" >   
                  <div class='message-contents'>
                      <div>
                      <h3>{{ message.event_type }}</h3> 
                      <p>Message: {{ message.message_text }} </p>
                      <p>Sender: {{ message.message_sender}} </p>
                      </div>
                      <div>
                      <button @click="removeMessage(message.id)">Completed</button>
                      <a href="slack://open" target='parent' title='open slack'><button tabindex='-1'>Slack</button></a>
                      </div>
                    </div>
                    <img src=${SLACK_IMG}>
                </div>
              </transition>
          `
    }

    const GitHubEvent = {
        name: 'GitHubEvent',
        props: {
            message: {
                type: Object,
                required: true,
            },
            markAsComplete: {
                type: Function,
                required: true,
            }
        },
        data() {
            return {
                show: false,
                clearAll: false,
            }
        },
        computed: {
            clearStack: () =>
                this.removeMessage()
        },
        methods: {
            flipShow() {
                this.show = !this.show
            },
            removeMessage(id) {
                this.flipShow();
                this.markAsComplete(id);
            },
        },
        created() {
            this.flipShow()
            EventHub.$on('clear-stack', function() {
                this.flipShow
            })
        },
        template: `
        <transition name="bounce">
          <div class='message' v-if="show" >   
            <div class='message-contents'>
                <div>
                <h3>{{ message.event_type }}</h3> 
                <p>Repo: {{ message.repo }} </p>
                <p>Sender: {{ message.from }}</p> 
                <p>Title: {{ message.title }}</p> 
                <p v-if="message.action">Action: {{message.action}} </p>
                </div>
                <div>
                <button @click="removeMessage(message.id)">Completed</button>
                <a :href="message.link" target='blank' title='open github'><button tabindex='-1'>Github</button></a>
                </div>
              </div>
              <img src=${GITHUB_IMG}>
          </div>
        </transition>
    `
    }

    new Vue({
        name: 'appMessages',
        el: '#app-messages',
        components: {
            GitHubEvent,
            SlackEvent,
            GmailEvent,
        },
        data() {
            return {
                user,
                messages: [],
                clearAll: false,
            };
        },

        methods: {
            fetchData(ping) {
                if (ping.user_id == this.user) {
                    $.ajax({
                            method: "get",
                            url: `${BACKEND_URI}?id=${this.user}`,
                        })
                        .then((data) => {
                            this.messages = data.messages;
                        });
                }
            },
            markAsComplete(id) {
                $.ajax({
                    method: "patch",
                    url: `${BACKEND_URI}?msg_id=${id}`,
                })

            },
            clearStack() {
                this.$refs.foo.forEach((msg) => {
                    if (msg.show) { msg.flipShow() }
                })
                $.ajax({
                    method: "put",
                    url: `${BACKEND_URI}?id=${this.user}`
                })
            }

        },
        created() {
            EventHub.$on('socket-update', this.fetchData);
            user_id = this.user
            this.fetchData({ user_id: user_id, service_id: [] });
        },
        template: `
        <div>
        <button @click ='clearStack' class='btn btn-lg btn-block clear-btn'> Clear Stack </button>
        <ul class='messages'>
          <li v-for="message in messages"  :key="message.id">
              <GitHubEvent ref='foo' v-if="message.provider === 'github'" :message="message" :markAsComplete="markAsComplete"/>
              <GmailEvent ref='foo' v-if="message.provider === 'google_oauth2'" :message="message" :markAsComplete="markAsComplete"/>
              <SlackEvent ref='foo' v-if="message.provider === 'slack'" :message="message" :markAsComplete="markAsComplete"/> 
          </li>
        </ul>
        </div>
      `,
    })

    const socket = io.connect(`https://my-stack-websocket.herokuapp.com`, {
        reconnect: true
    });

    socket.on('connect', () => console.log('connected'));
    socket.on("msg", (ping) => {
        EventHub.$emit('socket-update', ping)
    })
});
