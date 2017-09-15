class GoogleService
  attr_accessor :id
  def initialize(args)
    @id = args[:id] || nil
    @request = args[:request] || nil
  end

  def check_for_expiration
    update_service if service_expired?
  end
  
  def service_expired?
    @id.hook_expires_at < Time.now.to_i
  end

  def push_notification_id
    if @user 
      @id = @user.identities.where(provider: 'google_oauth2').first
    end
  end

  def client(token)
    client = Signet::OAuth2::Client.new(access_token: token.access_token)
    client.tap{|i| i.expires_in = Time.now + 1_000_000}
  end

  def service(client)
    service = Google::Apis::GmailV1::GmailService.new
    service.tap{|i| i.authorization = client}
  end

  def gmail_service
    token = Token.new(id)
    client = client(token)
    service(client)
  end

  def get_user_messages
    service   = gmail_service
    messages  = service.list_user_messages('me')
    msg_id    = messages.messages.first.id
    service.get_user_message('me', msg_id)
  end

  def push_notification_email
    @user ||= User.find_by_email(parse_push_notification['emailAddress'])
  end

  def parse_push_notification
    message = JSON.parse(@request.body.read)
    decoded = Base64.decode64(message['message']['data'])
    JSON.parse(decoded)
  end

  def update_service
    service                   = gmail_service
    watch_request             = Google::Apis::GmailV1::WatchRequest.new
    watch_request.topic_name  = 'projects/rich-tine-178917/topics/myStack'

    service.watch_user('me', watch_request)
    id.update_attributes(hooks_set: true, hook_expires: true, hook_expires_at: 7.days.from_now)
  end

  def cancel_service
    service = gmail_service

    service.stop_user('me')
    id.update_attributes(hooks_set: false, hook_expires: nil, hook_expires_at: nil)
  end
end
        