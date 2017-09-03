$(document).ready(function() {
    // ((glp) => {
    $('#reload-messages').on('click', function(event) {
            const user = $(event.currentTarget).data().id
            retrieveMessages(user)
        })
        // })(window.glp || (window.glp = {}));
})

function retrieveMessages() {


    // $.ajax({
    //         method: "get",
    //         url: `http://localhost:3000/pings/server?id=${user}`,
    //     })
    //     .then(function(data) {
    //         data.messages.forEach(function(message) {
    //             $('ul').append(`<li>
    //               <div class='gh-message'>
    //               <h3>${message.event_type}:<h3> 
    //               <p> Repo: ${message.repo} </p>
    //               <p> Sender:${message.from}</p> 
    //               <a href=${message.link}>See on Github</a> 
    //               </div>
    //               </li>`)
    //         })
    //     })
}