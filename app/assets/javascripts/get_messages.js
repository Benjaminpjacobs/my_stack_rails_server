document.addEventListener('DOMContentLoaded', () => {
    const BACKEND_URI = document.querySelector('#app-messages').dataset.url;
    const SOCKET_URI = document.querySelector('#app-messages').dataset.socket;
    const user = document.querySelector('#app-messages').dataset.id;
    const EventHub = new Vue({});

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
              <div>
                <h3>{{ message.event_type }}</h3> 
                <p> Repo: {{ message.repo }} </p>
                <p> Sender:{{ message.from }}</p> 
                <button @click="removeMessage(message.id)">Completed</button>
                <a :href="message.link" target='blank'><button>Github</button></a>
              </div>
              <img src='/assets/octocat.png'>
          </div>
        </transition>
    `
    }

    new Vue({
        name: 'appMessages',
        el: '#app-messages',
        components: {
            GitHubEvent,
        },
        data() {
            return {
                user,
                messages: [],
            };
        },
        methods: {
            fetchData(id) {
                $.ajax({
                        method: "get",
                        url: `${BACKEND_URI}?id=${this.user}`,
                    })
                    .then((data) => {
                        this.messages = data.messages;
                    });
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
            this.fetchData(this.user);
        },
        template: `
        <ul class='messages'>
          <li v-for="message in messages" :key="message.id">
              <GitHubEvent :message="message" :markAsComplete="markAsComplete" />
          </li>
        </ul>
      `,
    })

    const socket = io.connect(`https://my-stack-websocket.herokuapp.com`, {
        reconnect: true
    });

    socket.on('connect', () => console.log('connected'));
    socket.on("msg", (id) => EventHub.$emit('socket-update', id))
});