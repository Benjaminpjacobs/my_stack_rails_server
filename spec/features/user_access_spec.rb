require 'rails_helper'

RSpec.describe "Access" do
  include Devise::Test::IntegrationHelpers

  describe "as a user" do
    it "cannot access anything but root if not logged in" do
      
        visit hooks_path
        expect(current_path).to eq(root_path)
        visit main_path
        expect(current_path).to eq(root_path)
    end

    it "can access main when logged in" do
      github   = create(:service, name: 'github')
      id    = create(:identity, provider: github.name, uid: 'U70Q8ND1U')
      user  = id.user

      sign_in user

      visit main_path
      expect(current_path).to eq(main_path)
      expect(page.find("div[data-id='#{user.id}']")).to_not be nil
    end
  end
end