## MyStack: All the feeds you need

### Developer 
Benjamin Jacobs

### Project Name 
MyStack

### Summary 
A feed amalgamator that can be tailored to user preferences.

### Description 
In the modern digital age there are many feeds to track. Especially as developers we need to keep track of pull requests, emails, slack messages, blog posts, Twitter, Facebook…the list goes on and on. MyStack is an application that will pull all of these feeds into a central web application and allow you to organize and interact with incoming messages from a variety of origins. Users sign up and OAuth into their choice of services they want included on their Stack. They will then have access to a Dashboard where all of those selected feeds will be delivered in real time with appropriate action options(accept, dismiss, reply, review…). The UI will be reminiscent of an actual stack. Last in, first out. Message cards get pumped into a queue and can be added to the stack in priority order and are popped off by the user. There will also be a MyStackStats page offering personalized metrics from all accessible feeds such as message count, frequency and time of day trends.

### Technologies 
This project will include both familiar and unfamiliar elements to pull all the functionality together. It will be centered on a rails application that will handle OAuth for login and all services, as well as the database including users and service metrics. The rails application will implement WebHooks to grab pushed data from services and will then itself push that data to a Node.js server that will integrate Socket.Io with the front end client. The client will be a combination of Rails Views with Vue.js for UI fluidity with the incoming web socket elements. In later iterations a GraphQL layer will be implemented on top of the rails database to allow for efficient api calls for user metrics.

### Iterations
* Iteration1 - Build Rails Backend with OAuth for a single service that implements web hooks with the push data from that specific service. Deliver this upon refresh to a simple front-end rails view.
* Iteration2 - Build Node.js web server with Express and Socket.Io to handle the response to the web hooks from Rails and push data in real-time to the front-end rails view
* Iteration3 - Implement Vue.Js in the front end view to smooth out UI for incoming web socket data. 
* Iteration4 - Implement additional services on the rails backend with a UI to select and deselect individual services. Ideas include: Github, Slack, Twitter, Facebook, Gmail, and news headlines.
* Iteration5 - Scope all incoming message to different users and create user specific data metrics algorithms to serve client stack stats.
* Iteration6 - Implement GraphQL layer on top of data metrics api calls to be able to grab only data specific to users subscribed services

#### Conclusion 
This application will be an opportunity to learn a series of new technologies(Vue.js, GraphQL, Socket.IO) as well as refreshing and expanding the capabilities of Rails, OAuth, Services and Express that we have already covered in the curriculum. I know there will be plenty of challenges trying to incorporate multiple APIs into this one application but I am excited to find solutions and build a product that I would personally use on a daily basis.
