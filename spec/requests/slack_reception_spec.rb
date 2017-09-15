require 'rails_helper'

describe 'Slack Reception', :type => :request do
  context 'Message Received' do
    it "sends all messages" do
      VCR.use_cassette('slack_reception/receive_message') do
        allow_any_instance_of(SlackService).to receive(:get_user_name).and_return({'user'=> {'name'=> 'test_user'}})

        slack   = create(:service, name: 'slack')
        id    = create(:identity, provider: slack.id, uid: 'U70Q8ND1U')
        slack_message   = build(:slack_message)

        params = 
        {"token"=>"Clw9JQXt0MXA7dLHTeZDja1y",
        "team_id"=>"T7025KXGD",
        "api_app_id"=>"A6ZK8PV33",
        "event"=>{"type"=>"message", "user"=>"U70Q8ND1U", "text"=>"testing", "ts"=>"1505484598.000561", "channel"=>"C710SJY79", "event_ts"=>"1505484598.000561"},
        "type"=>"event_callback",
        "authed_users"=>["U70Q8ND1U"],
        "event_id"=>"Ev73TL83J9",
        "event_time"=>1505484598}

        post "/hooks/slack/reception", params: params.to_json
        
        expect(response).to be_success
        expect(response.status).to eq(200)

        msg = Message.last

        expect(msg.user_id).to eq(id.user.id)
        expect(msg.message['text']).to eq(params['event']['text'])
        expect(msg.message['user']).to eq('test_user')
        expect(msg.message['event_id']).to eq(params['event_id'])

      end
    end
  end
end