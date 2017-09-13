require 'rails_helper'

RSpec.describe Token do
  describe "instance methods" do
    it "acts as simple delegator" do
      id = create(:identity)
      token = Token.new(id)
      expect(token.refresh_token).to eq(id.refresh_token)
      expect(token.token).to eq(id.token)
      expect(token.provider).to eq(id.provider)
    end
    
    it "parameterizes items" do
      id = create(:identity)
      token = Token.new(id)
      params = token.to_params
      expect(params['refresh_token']).to eq(id.refresh_token)
      expect(params['client_id']).to eq(ENV['GOOGLE_ID'])
      expect(params['client_secret']).to eq(ENV['GOOGLE_SECRET'])
      expect(params['grant_type']).to eq('refresh_token')
    end

    it "should request token from google and update record" do
      VCR.use_cassette("token/google_response") do
        id = create(:identity)
        token = Token.new(id)
        token.refresh!
        expect(token.refresh_token).to eq(id.refresh_token)
        expect(token.token).to eq(id.token)
        expect(token.provider).to eq(id.provider)
      end
    end

    it "should provide access token" do
      id = create(:identity)
      token = Token.new(id)
      expect(token.access_token).to eq(id.token)
    end

    it "should automatically refresh if past due provide access token" do
      VCR.use_cassette("token/google_response") do
        id = create(:identity, expires_at: 1.day.ago.to_i)
        token = Token.new(id)

        expect(Time.at(token.expires_at)).to be < Time.now
        
        token.access_token

        expect(Time.at(token.expires_at)).to be > Time.now
        expect(Time.at(id.expires_at)).to be > Time.now
        expect(token.access_token).to eq('1a2s3d4a5d6g')
      end
    end

  end  
  
end