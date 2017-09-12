class MainController < ApplicationController
  def index
    id = current_user.identities.where(provider: 'google_oauth2').first
    if id && id.hooks_set
      service = GoogleService.new(id)
      service.check_for_expiration
    end
    @msg_url = ENV['MSG_URL']
    @socket_url = ENV['SOCKET_URL']
  end
end