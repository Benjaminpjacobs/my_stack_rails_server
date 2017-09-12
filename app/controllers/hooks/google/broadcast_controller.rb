class Hooks::Google::BroadcastController < ApplicationController
    def new
      token = current_user.identities.where(provider: 'google_oauth2').first.token
      client = Signet::OAuth2::Client.new(access_token: token)
      client.expires_in = Time.now + 1_000_000
      service = Google::Apis::GmailV1::GmailService.new
      service.authorization = client

      watch_request = Google::Apis::GmailV1::WatchRequest.new
      watch_request.topic_name= 'projects/rich-tine-178917/topics/myStack'
      service.watch_user('me', watch_request)
      redirect_to main_path
    end
end