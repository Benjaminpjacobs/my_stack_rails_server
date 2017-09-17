require 'rails_helper'

describe 'Slack Reception', :type => :request do
  context 'Message Received' do
    it 'sends all messages' do
      VCR.use_cassette('github_reception/receive_message') do

        github   = create(:service, name: 'github')
        id    = create(:identity, provider: github.id, uid: 'U70Q8ND1U')
        github_message   = build(:slack_message)

        params = 
        {
          "sender" => {
              "id" => id.uid
          },
          "action"=>"an action",
          "repository"=>{
              "name"=>"a name"
              },
          "pull_request"=>{
              "html_url"=>"url", 
              "title"=>"a title", 
              "body"=>"a body", 
              "state"=>"a state", 
              "created_at"=>"a time", 
              "user"=>{
                "login" => "a username"
              }
            },
        }

        req_headers = { 'X-Github-Event': "pull_request" }
        post "/hooks/github/reception", xhr: true, params: params.to_json, headers: req_headers
        
        expect(response).to be_success
        expect(response.status).to eq(200)

        msg = Message.last

        expect(msg.user_id).to eq(id.user.id)
        expect(msg.message['url']).to eq(params['pull_request']['html_url'])
        expect(msg.message['body']).to eq(params['pull_request']['body'])
        expect(msg.message['repo']).to eq(params['repository']["name"])
        expect(msg.message['state']).to eq(params['pull_request']['state'])
        expect(msg.message['title']).to eq(params['pull_request']['title'])
        expect(msg.message['action']).to eq(params['action'])
        expect(msg.message['sender']).to eq(params['pull_request']['user']['login'])
        expect(msg.message['created_at']).to eq(params['pull_request']['created_at'])

      end
    end
  end
end