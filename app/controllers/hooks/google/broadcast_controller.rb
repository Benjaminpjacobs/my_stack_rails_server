class Hooks::Google::BroadcastController < ApplicationController
    def new
      id = current_user.identities.where(provider: 'google_oauth2').first
      google_service = GoogleService({id: id})
      google_service.update_service

      redirect_to request.referer
    end

    def delete
      id = current_user.identities.where(provider: 'google_oauth2').first
      token = Token.new(id)
      client = Signet::OAuth2::Client.new(access_token: token.access_token)
      client.expires_in = Time.now + 1_000_000
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
      service.stop_user('me')
      id.update_attributes(hooks_set: false, hook_expires: nil, hook_expires_at: nil)
      redirect_to request.referer
    end
end