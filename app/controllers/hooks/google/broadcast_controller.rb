class Hooks::Google::BroadcastController < ApplicationController
    def new
      id = current_user.identities.where(provider: 'google_oauth2').first
      token = Token.new(id)
      client = Signet::OAuth2::Client.new(access_token: token.access_token)
      client.expires_in = Time.now + 1_000_000
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client
      watch_request = Google::Apis::GmailV1::WatchRequest.new
      watch_request.topic_name= 'projects/rich-tine-178917/topics/myStack'
      response = service.watch_user('me', watch_request)
      id.update_attributes(hooks_set: true, hook_expires: true, hook_expires_at: 7.days.from_now)
      redirect_to main_path
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
      redirect_to main_path
    end
end