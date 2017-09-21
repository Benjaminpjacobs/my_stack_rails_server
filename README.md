## MyStack: All the feeds you need ![Travis Badge](https://travis-ci.org/Benjaminpjacobs/my_stack_rails_server.svg?branch=master) 

![alt text](https://raw.githubusercontent.com/Benjaminpjacobs/my_stack_rails_server/master/images/myStackSS.png)

### Summary 
A feed amalgamator that can be tailored to user preferences.

### Description 

In the modern digital age there are many feeds to track. Items such as pull requests, emails, Slack messages, blog posts, Twitter, Facebook…the list goes on and on. MyStack attempts to solve this problem by amalgamating feeds into a central web application and allowing the user to organize and interact with incoming messages from a variety of origins. Users sign up and OAuth into their choice of services they want included on their Stack. They then have access to a Dashboard where all of those selected feeds will be delivered in real time with appropriate action options(accept, dismiss, reply, review…). The UI will be reminiscent of an actual stack. Last in, first out. 

### The Stack's Stack

At its core this project is a Rails 5 application. It utilizes a postegres database for users, messages and services. Aside from rails views Vue.js is the heart of the main application page allowing for interactivity and a fluid realtime UI. Also serving this application is a separate Node.js running an [Express service](https://github.com/Benjaminpjacobs/my_stack_express_server). This separate service keep the open socket connection between the server and view for the delivery of messages to front end in real time without a reload. 

### To Run Locally

If you are interested in running myStack in a local development environment then proceed with the following:

* Clone Down the Repository
* bundle install
* rake db:setup

This will get the basic development environment setup for you. In addition you will need to configure some external services in order to interact with realtime notifications. You will need to register an application with [Google](https://developers.google.com/actions/identity/oauth2-code-flow), [Slack](https://api.slack.com/docs/oauth), [Github](https://developer.github.com/apps/building-integrations/setting-up-and-registering-oauth-apps/) and [Facebook](https://developers.facebook.com/docs/facebook-login/web/)(See issues/feature development) in order to obtain Client IDs and Secrets and have OAuth work correctly. Additionally you will have to setup [Google pub/sub/hub](https://developers.google.com/gmail/api/guides/push) in order to get those push notifications working. After you have obtained these credentials:

* fiagro install

Navigate to the application.yml and enter all your credentials in the following format:

```
development:
  GITHUB_KEY: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  GITHUB_SECRET: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  GITHUB_WEBHOOK_SECRET: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  GITHUB_WEBHOOK_URL:  https://dc62eae5.ngrok.io/hooks/github/reception
  MSG_URL: http://localhost:3000/pings/server
  SOCKET_URL: https://my-stack-websocket.herokuapp.com
  GOOGLE_ID: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  GOOGLE_SECRET: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  
  SLACK_APP_ID: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  SLACK_APP_SECRET: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  FACEBOOK_ID: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  FACEBOOK_SECRET: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  FACEBOOK_TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  FACEBOOK_APP_ACCESS_TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  ```
You will also need something like [ngrok](https://gist.github.com/wosephjeber/aa174fb851dfe87e644e) in order to expose your local host to the web. Once installed run `ngrok` in a terminal pain and replace `https://dc62eae5.ngrok.io` in the github webhook url with your own ngrok address. This will similarly be the development url you will use for google pub/sub as well as facebook and slack push notifications when you configure those settings.

Once this is all configured you can run `rails s` and get your local server running. Navigate to `http://localhost:3000` and you should see the myStack entrace page which is comprised of OAuth links to various services. Here you can log into your accounts(or mock accounts) and play with the real time notification elements. 

Note that the separate Express socket server will still work for your local environment remotely, but if for any reason you'd like to run that locally as well simply navigate [this repo](https://github.com/Benjaminpjacobs/my_stack_express_server), clone down and npm start. However, you will have to change the pointers within this app to look at your local development enviornment.

### Current Issues - Future Features

At this stage of development OAuth is configured for Slack, Gmail, Google and Facebook. Realtime notifications however are currently only configured for Slack, Gmail and Google. There are no outstanding issues other than finding more efficient ways of scraping google data messages to allow for better text formating. There are many features that would be an excellent addition to this application and they are as follows:

* Finish the integration of Facebook in order for feed, messages and friend requests to notifiy myStack.
* Finish OAuth and Notification implemenetation of Twitter
* Incorporate other services such as Google Calendar Events, News Feed, Linkedin Notifications etc.
* Allow for two way interactions with services. 
  * Currently when a google message is marked complete on mystack it is marked as read on google. It would be ideal to take     this futher
  * Allow for direct slack communication within the app
  * Allow for gmail responses from within the app
  * Allow for remote approval of pull requests(This would probably require more verbose information on the PR in order to be    useful)
* Include a user dashboard with would offer interesting statistics on message frequency, volume, etc.
