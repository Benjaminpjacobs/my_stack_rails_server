require "rails_helper"

RSpec.describe SlackService do
  it "can retrieve user name" do
      VCR.use_cassette("slack/get_user_name", :match_requests_on => [:host]) do
      token = "xxxx-xxxx-xxxx-xxxx"
      uid = "UUUUUUUUU"
      service = SlackService.new(token)
      user = service.get_user_name(uid)
      
      expect(user).to be_a Hash
      expect(user['ok']).to be true
      expect(user['user']).to have_key('id')
      expect(user['user']).to have_key('team_id')
      expect(user['user']).to have_key('name')
      expect(user['user']).to have_key('real_name')
      expect(user['user']).to have_key('profile')
    end
  end
  
end