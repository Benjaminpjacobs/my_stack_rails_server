require 'rails_helper'

RSpec.describe "Login" do
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  describe "as a user" do
    context "it sees correct options"do
      it "when logged in with github" do
        
        github   = create(:service, name: 'github')
        id    = create(:identity, provider: github.name, uid: 'U70Q8ND1U')
        user  = id.user
        
        sign_in user

        visit hooks_path

        expect(page).to have_content('Set Github Hooks')
        expect(page).to have_content('Authorize Google')
        expect(page).to have_content('Authorize Slack')
      end
      it "when logged in with google" do
        
        google   = create(:service, name: 'google_oauth2')
        id    = create(:identity, provider: google.name, uid: 'U70Q8ND1U')
        user  = id.user
        
        sign_in user

        visit hooks_path

        expect(page).to have_content('Set Google Hooks')
        expect(page).to have_content('Authorize Github')
        expect(page).to have_content('Authorize Slack')
      end
      it "when logged in with slack" do
        
        slack   = create(:service, name: 'slack')
        id    = create(:identity, provider: slack.name, uid: 'U70Q8ND1U')
        user  = id.user
        
        sign_in user

        visit hooks_path

        expect(page).to have_content('Delete Slack Hooks')
        expect(page).to have_content('Authorize Google')
        expect(page).to have_content('Authorize Github')
      end
    end
    
    context "it can set and delete hooks" do
      it "for github" do 
        ActiveJob::Base.queue_adapter = :test
        allow_any_instance_of(GithubService).to receive(:set_all_web_hooks).and_return(true)
        allow_any_instance_of(GithubService).to receive(:delete_all_web_hooks).and_return(true)

        github   = create(:service, name: 'github')
        id    = create(:identity, provider: github.name, uid: 'U70Q8ND1U')
        user  = id.user
        
        sign_in user

        visit hooks_path
        click_link 'Set Github Hooks'
        expect(current_path).to eq(hooks_path)
        expect(page).to have_content('Delete Github Hooks')
        expect(page).to have_content('Update Github Hooks')
        
        click_link 'Delete Github Hooks'
        expect(current_path).to eq(hooks_path)
        expect(page).to have_content('Set Github Hooks')

        expect(GithubHooksJob).to have_been_enqueued.exactly(:twice)
      end

      it "for google" do 
        google   = create(:service, name: 'google_oauth2')
        id    = create(:identity, provider: google.name, uid: 'U70Q8ND1U')
        user  = id.user

        allow_any_instance_of(Google::Apis::GmailV1::GmailService).to receive(:watch_user).and_return(true)
        allow_any_instance_of(Google::Apis::GmailV1::GmailService).to receive(:stop_user).and_return(true)
        
        sign_in user

        visit hooks_path
        click_link 'Set Google Hooks'
        expect(current_path).to eq(hooks_path)
        expect(page).to have_content('Delete Google Hooks')

        click_link 'Delete Google Hooks'
        expect(current_path).to eq(hooks_path)
        expect(page).to have_content('Set Google Hooks')
      end

      it "for slack" do 
        slack   = create(:service, name: 'slack')
        id    = create(:identity, provider: slack.name, uid: 'U70Q8ND1U')
        user  = id.user

        sign_in user

        visit hooks_path
        click_link 'Delete Slack Hooks'
        expect(current_path).to eq(hooks_path)
        expect(page).to have_content('Authorize Slack')
        expect(user.identities.empty?).to be true
      end
    end
  end
end