class Hooks::Google::BroadcastController < ApplicationController
    def new
      id = current_user.identities.where(provider: 'google_oauth2').first
      google_service = GoogleService.new({id: id})
      google_service.update_service
      redirect_to request.referer
    end

    def delete
      id = current_user.identities.where(provider: 'google_oauth2').first
      google_service = GoogleService.new({id: id})
      google_service.cancel_service
      redirect_to request.referer
    end
end