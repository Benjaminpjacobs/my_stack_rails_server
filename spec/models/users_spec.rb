require 'rails_helper'

RSpec.describe User do

  it {should have_many(:identities)}
  it {should have_many(:messages)}

  describe "class_methods" do
    it "should find and log in a user based on auth" do
      @identity = create(:identity)
      @auth_mock_identity = OpenStruct.new(
        info: OpenStruct.new(
          email: @identity.user.email
        ),
        uid: @identity.uid,
        provider: @identity.provider,
        credentials: OpenStruct.new(
          token: @identity.token,
          refresh_token: @identity.refresh_token,
          expires_at: @identity.expires_at
        )
      )
      userA = User.find_for_oauth(@auth_mock_identity)
      expect(userA).to eq(@identity.user)
    end

    it "should initiate a new user if not found" do
      @auth_mock_temp= OpenStruct.new(
        info: OpenStruct.new(
          email: "new@exmple.com"
        ),
        uid: '123456',
        provider: 'google',
        credentials: OpenStruct.new(
          token: '1234asdfg',
          refresh_token: '123654asd',
          expires_at: 1.hour.from_now
        ),
        extra: OpenStruct.new(
          raw_info: OpenStruct.new(
            name: "new example"
          )
        )
      )
      expect(User.count).to eq(1)
      user = User.find_for_oauth(@auth_mock_temp)
      expect(User.count).to eq(2)
    end
  end
end
