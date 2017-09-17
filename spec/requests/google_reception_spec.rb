require 'rails_helper'

describe 'Google Reception', :type => :request do
  context 'Message Received' do
    it "stores a valid message" do
      VCR.use_cassette('google_reception/receive_message') do
        google              = create(:service, name: 'google_oauth2')
        id                  = create(:identity, provider: google.id, uid: 'U70Q8ND1U')
        slack_message       = build(:google_message)
        google_message_mock = OpenStruct.new({
          user: id.user,
          provider: google,
          msg: OpenStruct.new({
              label_ids: ['UNREAD', 'INBOX'],
              payload: OpenStruct.new({
                                        headers: [
                                                OpenStruct.new({name:'Subject', value: "This is the subject"}),
                                                OpenStruct.new({name:'From', value:'example@test.com'})
                                                ],
                                        parts: [
                                                OpenStruct.new({body: OpenStruct.new({data: 'This is the data'})})
                                               ],        
                                      }),
              parts: "parts",
              snippet: "This is the snippet",
              id: "GOOGLEID",
              })
        })
        allow_any_instance_of(GoogleHelper).to receive(:objectify).and_return(google_message_mock)

        post "/hooks/google/reception", params: {}.to_json
        
        expect(response).to be_success
        expect(response.status).to eq(200)
        msg = Message.last

        expect(msg.user_id).to eq(id.user.id)
        expect(msg.message['from']).to eq("example@test.com")
        expect(msg.message['snippet']).to eq('This is the snippet')
        expect(msg.message['subject']).to eq('This is the subject')
        expect(msg.message['google_id']).to eq('GOOGLEID')
        expect(msg.message['full_message']).to eq('This is the data')
      end
    end

    it "doesn't store an invalid message" do
      VCR.use_cassette('google_reception/receive_message') do
        google              = create(:service, name: 'google_oauth2')
        id                  = create(:identity, provider: google.id, uid: 'U70Q8ND1U')
        slack_message       = build(:google_message)
        google_message_mock = OpenStruct.new({
          user: id.user,
          provider: google,
          msg: OpenStruct.new({
              label_ids: ['UNREAD', 'INBOX', 'CATEGORY_PROMOTIONS'],
              })
        })
        allow_any_instance_of(GoogleHelper).to receive(:objectify).and_return(google_message_mock)

        expect(Message.count).to eq(0)
        post "/hooks/google/reception", params: {}.to_json
        
        expect(response).to be_success
        expect(response.status).to eq(200)
        expect(Message.count).to eq(0)
        
      end
    end
  end
  
  it "doesn't store the same message twice a valid message" do
    VCR.use_cassette('google_reception/receive_message') do
      google              = create(:service, name: 'google_oauth2')
      id                  = create(:identity, provider: google.id, uid: 'U70Q8ND1U')
      slack_message       = build(:google_message)
      google_message_mock = OpenStruct.new({
        user: id.user,
        provider: google,
        msg: OpenStruct.new({
            label_ids: ['UNREAD', 'INBOX'],
            payload: OpenStruct.new({
                                      headers: [
                                              OpenStruct.new({name:'Subject', value: "This is the subject"}),
                                              OpenStruct.new({name:'From', value:'example@test.com'})
                                              ],
                                      parts: [
                                              OpenStruct.new({body: OpenStruct.new({data: 'This is the data'})})
                                             ],        
                                    }),
            parts: "parts",
            snippet: "This is the snippet",
            id: "GOOGLEID",
            })
      })
      allow_any_instance_of(GoogleHelper).to receive(:objectify).and_return(google_message_mock)

      post "/hooks/google/reception", params: {}.to_json
      
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(Message.count).to eq(1)
      
      post "/hooks/google/reception", params: {}.to_json
            
      expect(response).to be_success
      expect(response.status).to eq(200)
      expect(Message.count).to eq(1)
    end
  end
end