class Hooks::Google::BroadcastController < ApplicationController
  before_action :set_identity
  before_action :set_google_service
    def new
      @google_service.update_service
      redirect_to request.referer
    end

    def delete
      @google_service.cancel_service
      redirect_to request.referer
    end

    private
    
    def set_identity
      @id = current_user.identities.where(provider: 'google_oauth2').first
    end

    def set_google_service
      @google_service = GoogleService.new({id: @id})
    end
end