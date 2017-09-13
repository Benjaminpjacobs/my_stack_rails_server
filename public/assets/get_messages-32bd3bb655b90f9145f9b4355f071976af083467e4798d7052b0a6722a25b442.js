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
            }
        },
        data() {
            return {
                show: false,
            }
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
        },
        template: `
            <transition name="bounce">
              <div class='message' v-if="show" >   
                  <div class='message-contents'>
                    <h3>{{ message.event_type }}</h3> 
                    <p> Subject: {{ message.subject }} </p>
                    <p> From: {{ message.email_address}} </p>
                    <p> Message: {{ message.snippet }} </p>
                    <button @click="removeMessage(message.id)">Completed</button>
                    <a href="https://www.gmail.com" target='blank'><button>Gmail</button></a>
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
            }
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
        },
        template: `
              <transition name="bounce">
                <div class='message' v-if="show" >   
                  <div class='message-contents'>
                      <h3>{{ message.event_type }}</h3> 
                      <p> Message: {{ message.message_text }} </p>
                      <p>sender: {{ message.message_sender}} </p>
                      <button @click="removeMessage(message.id)">Completed</button>
                      <a href="slack://open" target='blank'><button>Slack</button></a>
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
            }
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
        },
        template: `
        <transition name="bounce">
          <div class='message' v-if="show" >   
            <div class='message-contents'>
                <h3>{{ message.event_type }}</h3> 
                <p> Repo: {{ message.repo }} </p>
                <p> Sender:{{ message.from }}</p> 
                <button @click="removeMessage(message.id)">Completed</button>
                <a :href="message.link" target='blank'><button>Github</button></a>
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
        },
        created() {
            EventHub.$on('socket-update', this.fetchData);
            user_id = this.user
            this.fetchData({ user_id: user_id, service_id: [] });
        },
        template: `
        <ul class='messages'>
          <li v-for="message in messages"  :key="message.id">
              <GitHubEvent v-if="message.provider === 'github'" :message="message" :markAsComplete="markAsComplete" />
              <GmailEvent v-if="message.provider === 'google_oauth2'" :message="message" :markAsComplete="markAsComplete" />
              <SlackEvent v-if="message.provider === 'slack'" :message="message" :markAsComplete="markAsComplete" />
          </li>
        </ul>
      `,
    })

    const socket = io.connect(`https://my-stack-websocket.herokuapp.com`, {
        reconnect: true
    });


    // const socket = io.connect(`http://localhost:8080`, {
    //     reconnect: true
    // });

    socket.on('connect', () => console.log('connected'));
    socket.on("msg", (ping) => {
        EventHub.$emit('socket-update', ping)
    })
});