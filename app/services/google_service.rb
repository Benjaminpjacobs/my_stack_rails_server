class GoogleService
  def initialize(id)
    @id = id
  end

  def check_for_expiration
    update_service if service_expired?
  end
  
  def service_expired?
    @id.hook_expires_at < Time.now.to_i
  end

  def update_service
    token = Token.new(@id)
    client = Signet::OAuth2::Client.new(access_token: token.access_token)
    client.expires_in = Time.now + 1_000_000
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = client
    watch_request = Google::Apis::GmailV1::WatchRequest.new
    watch_request.topic_name= 'projects/rich-tine-178917/topics/myStack'
    response = service.watch_user('me', watch_request)
    @id.update_attributes(hooks_set: true, hook_expires: true, hook_expires_at: 7.days.from_now)
  end
end
        