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
            },
        },
        template: `
      <div class='message'> 
          <h3>{{ message.event_type }}</h3> 
          <p> Repo: {{ message.repo }} </p>
          <p> Sender:{{ message.from }}</p> 
          <button @click="markAsComplete(message.id)">Completed</button>
          <a :href="message.link" target='blank'>See on Github</a>
          <img src='app/assets/images/octocat.png'>
      </div>
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
                if (id === this.user) {
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
                    .then(() => {
                        this.fetchData(this.user)
                    })
            },
        },
        created() {
            EventHub.$on('socket-update', this.fetchData);
            this.fetchData(this.user);
        },
        template: `
        <ul>
          <li v-for="message in messages" :key="message.id">
              <GitHubEvent :message="message" :markAsComplete="markAsComplete" />
          </li>
        </ul>
      `,
    })

    const socket =
        io.connect(
            `${SOCKET_URI}`, {
                reconnect: true
            }
        )
    socket.on("msg", (id) => EventHub.$emit('socket-update', id))
});
