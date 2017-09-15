class Hooks::Google::ReceptionController < HookBaseController
  def received
    google_service  = GoogleService.new({request: request})
    user            = google_service.push_notification_email
    id              = google_service.push_notification_id
    provider        = Service.find_by_name(id.provider) if id
    msg             = google_service.get_user_messages if id
    
    if msg && msg.label_ids.include?('UNREAD') && msg.label_ids.include?('INBOX') && new_message?(msg.id)
      notify_client(user, provider) if format_and_save_message(msg,user,provider)
    end
  end

  def format_and_save_message(msg,user,provider)
    message = Message.google_format(msg, 'message', user, provider )
    Message.create(message)
  end

  def notify_client(user, provider)
    service = WebsocketService.new
    service.post_message({user_id: user.id, service_id: provider.id})
  end

  def new_message?(id)
    Message.where("message @> 'google_id=>#{id}'").empty?
  end
end