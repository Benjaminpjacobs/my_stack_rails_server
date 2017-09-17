require 'rails_helper'

RSpec.describe "Login" do
  context "as a user" do
    it "can login with github" do
      
      visit root_path

      expect(page).to have_content("Sign in with Github")
      expect(page).to have_content("Sign in with Google")
      expect(page).to have_content("Sign in with Slack")
      mock_auth_hash_github
      
      click_link 'Sign in with Github'
      expect(current_path).to eq(hooks_path)
      user = User.last
      id = user.identities.first
      expect(user.name).to eq('mockname')
      expect(user.email).to eq('mockemail@example.com')
      expect(id.provider).to eq('github')
      expect(id.uid).to eq('12345')
      expect(id.token).to eq('mock_token')
    end

    it "can login with google" do
      
      visit root_path

      expect(page).to have_content("Sign in with Github")
      expect(page).to have_content("Sign in with Google")
      expect(page).to have_content("Sign in with Slack")
      
      mock_auth_hash_google
      
      click_link 'Sign in with Google'
      expect(current_path).to eq(hooks_path)
      user = User.last
      id = user.identities.first
      expect(user.name).to eq('mockname')
      expect(user.email).to eq('mockemail@example.com')
      expect(id.provider).to eq('google')
      expect(id.uid).to eq('12345')
      expect(id.token).to eq('mock_token')
    end

    it "can login with google" do
      
      visit root_path

      expect(page).to have_content("Sign in with Github")
      expect(page).to have_content("Sign in with Google")
      expect(page).to have_content("Sign in with Slack")
      
      mock_auth_hash_slack
      
      click_link 'Sign in with Slack'
      expect(current_path).to eq(hooks_path)
      user = User.last
      id = user.identities.first
      expect(user.name).to eq('mockname')
      expect(user.email).to eq('mockemail@example.com')
      expect(id.provider).to eq('slack')
      expect(id.uid).to eq('12345')
      expect(id.token).to eq('mock_token')
    end

    it "can handle failed login" do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
      
      visit root_path
      click_link 'Sign in with Google'
      save_and_open_page
      expect(current_path).to eq(root_path)
    end
  end
end