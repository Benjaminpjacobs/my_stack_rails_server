require 'rails_helper'

RSpec.describe GoogleService  do
  before do
    @id = create(:identity, 
                  provider: 'google_oauth', 
                  uid:'12345', 
                  token: "lmnop12345", 
                  refresh_token: "lmnop09876",
                  hook_expires_at: 1.day.ago,
                  hook_expires: true,
                  hooks_set: false
                  )
    @service = GoogleService.new({id: @id})
  end

  it "can be initialized with id" do
    expect(@service).to be_instance_of(GoogleService)
  end

  it "knows if it's hook is expired" do
    expect(@service.service_expired?).to be true
  end

  it "can update watch request" do
    VCR.use_cassette("google/set_watch") do
      expect(@id.hooks_set).to be false
      expect(@id.hook_expires_at).to be < Time.now.to_i
      
      @service.update_service
      
      expect(@id.hooks_set).to be true
      expect(@id.hook_expires_at).to be > Time.now.to_i
    end
  end

  it "can stop a watch request" do
    VCR.use_cassette("google/delete_watch") do
      @service.cancel_service
      
      expect(@id.hooks_set).to be false
      expect(@id.hook_expires).to be nil
      expect(@id.hook_expires_at).to be nil
    end
  end

  
end