require 'rails_helper'

RSpec.describe "Access" do
  include Devise::Test::IntegrationHelpers

  describe "as a guest" do
    it "cannot access anything but root login" do
      
        visit hooks_path
        expect(current_path).to eq(root_path)
        visit main_path
        expect(current_path).to eq(root_path)

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