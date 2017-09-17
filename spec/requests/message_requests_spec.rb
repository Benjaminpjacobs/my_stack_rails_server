require 'rails_helper'

describe 'Pings' do
  context 'GET messages' do
    it "sends all messages" do
      user    = create(:user)
      github  = create(:service, name: 'github')
      slack   = create(:service, name: 'slack')
      google  = create(:service, name: 'google')
      
      gh_pull         = create(:github_pull_request, service_id: github.id, user_id: user.id)
      gh_issue        = create(:github_issue, service_id: github.id, user_id: user.id)
      slack_message   = create(:slack_message, service_id: slack.id, user_id: user.id)
      google_message  = create(:google_message, service_id: google.id, user_id: user.id)

      get "/pings/server?id=#{user.id}" 
      expect(response).to be_success

      data = JSON.parse(response.body)
      pull_request = data['messages'][3]
      issue = data['messages'][2]
      slack_msg = data['messages'][1]
      google_msg = data['messages'][0]
      
      expect(data).to have_key('messages')
      expect(data['messages'].length).to eq(4)
      expect(data['messages']).to be_an Array
      expect(pull_request['repo']).to eq(gh_pull.message['repo'])
      expect(pull_request['from']).to eq(gh_pull.message['sender'])
      expect(pull_request['link']).to eq(gh_pull.message['url'])
      expect(pull_request['title']).to eq(gh_pull.message['title'])
      expect(pull_request['body']).to eq(gh_pull.message['body'])

      expect(issue['repo']).to eq(gh_issue.message['repo'])
      expect(issue['from']).to eq(gh_issue.message['sender'])
      expect(issue['link']).to eq(gh_issue.message['url'])
      expect(issue['title']).to eq(gh_issue.message['title'])
      expect(issue['body']).to eq(gh_issue.message['body'])

      expect(slack_msg['message_sender']).to eq(slack_message.message['user'])
      expect(slack_msg['message_text']).to eq(slack_message.message['text'])
      
      expect(google_msg['email_address']).to eq(google_message.message['from'])
      expect(google_msg['snippet']).to eq(google_message.message['snippet'])
    end
  end

  context 'PATCH messages' do
    it 'changes message status' do
      user    = create(:user)
      slack   = create(:service, name: 'slack')
      slack_message   = create(:slack_message, service_id: slack.id, user_id: user.id)
      
      expect(Message.first.received?).to be true

      patch "/pings/server?msg_id=#{slack_message.id}"

      expect(response).to be_success
      expect(response.status).to eq(204)
      expect(Message.first.archived?).to be true
      
    end

    it 'only returns messages with proper status' do
      user    = create(:user)
      github  = create(:service, name: 'github')
      slack   = create(:service, name: 'slack')
      google  = create(:service, name: 'google')
      
      gh_pull         = create(:github_pull_request, service_id: github.id, user_id: user.id)
      gh_issue        = create(:github_issue, service_id: github.id, user_id: user.id)
      slack_message   = create(:slack_message, service_id: slack.id, user_id: user.id)
      google_message  = create(:google_message, service_id: google.id, user_id: user.id)   
      
      get "/pings/server?id=#{user.id}"
      data = JSON.parse(response.body)
      expect(data['messages'].length).to eq(4)

      patch "/pings/server?msg_id=#{slack_message.id}"
      
      get "/pings/server?id=#{user.id}"
      data = JSON.parse(response.body)
      expect(data['messages'].length).to eq(3)
    end
  end

  context "PUT Messages" do
    it "clears all messages" do
      user    = create(:user)
      github  = create(:service, name: 'github')
      slack   = create(:service, name: 'slack')
      google  = create(:service, name: 'google')
      user2    = create(:user)
      
      create(:github_pull_request, service_id: github.id, user_id: user.id)
      create(:github_issue, service_id: github.id, user_id: user.id)
      create(:slack_message, service_id: slack.id, user_id: user.id)
      create(:google_message, service_id: google.id, user_id: user.id)  
      create(:github_pull_request, service_id: github.id, user_id: user2.id)
      create(:github_issue, service_id: github.id, user_id: user2.id)
      create(:slack_message, service_id: slack.id, user_id: user2.id)
      create(:google_message, service_id: google.id, user_id: user2.id)  
      
      
      get "/pings/server?id=#{user.id}"
      data = JSON.parse(response.body)
      expect(data['messages'].length).to eq(4)
      
      put "/pings/server?id=#{user.id}"

      expect(user.messages.pluck(:status).uniq.count).to eq(1)
      expect(user.messages.pluck(:status).uniq.first).to eq("archived")
      expect(user2.messages.pluck(:status).uniq.count).to eq(1)
      expect(user2.messages.pluck(:status).uniq.first).to eq("received")
    end
  end
end