class Hooks::Google::ReceptionController < HookBaseController
  def received
    message = JSON.parse(request.body.read)
    decoded = Base64.decode64(message['message']['data'])
    parsed = JSON.parse(decoded)

    user = User.find_by_email(parsed['emailAddress'])
    id = user.identities.where(provider: 'google_oauth2').first
    token = Token.new(id)
    client = Signet::OAuth2::Client.new(access_token: token.access_token)
    client.expires_in = Time.now + 1_000_000
    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = client
    
    messages = service.list_user_messages('me')
    id =messages.messages.first.id
    msg = service.get_user_message('me', id)

    subject_header =  msg.payload.headers.select{|header| header.name == "Subject"}.first
    subject = subject_header ? subject_header.value : "(no subject)"

    from =  msg.payload.headers.select{|header| header.name == "From"}.first.value
    
    snippet = msg.snippet
    
    data = msg.payload.parts.first.body.data
    payload = {from: from, snippet: snippet, data: data, subject: subject}
    
    if msg.label_ids.include?('UNREAD') && msg.label_ids.include?('INBOX')
      Message.store(payload, user, 'message', 'google_oauth2')
      service = WebsocketService.new
      service.post_message({user_id: user.id, service_id: 3})
    end
  end

end