require 'rails_helper'

RSpec.describe "Login" do
  include Devise::Test::IntegrationHelpers
  context "as a user" do
    it "can login with github" do
      
      github   = create(:service, name: 'github')
      id    = create(:identity, provider: github.name, uid: 'U70Q8ND1U')
      user  = id.user
      binding.pry
      
      sign_in user

      visit hooks_path
      expect(page).to have_content('Set Github Hooks')
      expect(page).to have_content('Authorize Google')
      expect(page).to have_content('Authorize Slack')

      
    end
  end
end