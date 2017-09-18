require 'rails_helper'

RSpec.describe Identity do
  it {should belong_to(:user) }
  it {should validate_presence_of(:uid)}
  it {should validate_presence_of(:provider)}

  describe '#find_for_oauth' do
    before do
      @temp = build(:identity)
      @auth_mock_temp = OpenStruct.new(
        uid: @temp.uid,
        provider: @temp.provider,
        credentials: OpenStruct.new(
          token: @temp.token,
          refresh_token: @temp.refresh_token,
          expires_at: @temp.expires_at
        )
      )

      @id = create(:identity)
      @auth_mock_id = OpenStruct.new(
        uid: @id.uid,
        provider: @id.provider,
        credentials: OpenStruct.new(
          token: @id.token,
          refresh_token: @id.refresh_token,
          expires_at: @id.expires_at
        )
      )
    end

    it "create id if it does not exist and doesn't save if new record" do
      expect(Identity.count).to eq(1)

      id = Identity.find_for_oauth(@auth_mock_id)

      expect(id.uid).to eq(@temp.uid)
      expect(id.token).to eq(@temp.token)
      expect(id.provider).to eq(@temp.provider)
      expect(id.refresh_token).to eq(@temp.refresh_token)
      expect(id.expires_at).to eq(@temp.expires_at)

      expect(Identity.count).to eq(1)
    end

    it "finds identity if it exists" do

      id = Identity.find_for_oauth(@auth_mock_temp)

      expect(id.uid).to eq(@id.uid)
      expect(id.token).to eq(@id.token)
      expect(id.provider).to eq(@id.provider)
      expect(id.refresh_token).to eq(@id.refresh_token)
      expect(id.expires_at).to eq(@id.expires_at)

      expect(Identity.count).to eq(1)
    end

  end
end
