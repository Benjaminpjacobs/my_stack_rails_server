module GoogleHelper
  extend ActiveSupport::Concern
  
  def objectify(request)
    google_service  = GoogleService.new({request: request})
    user            = google_service.push_notification_email
    id              = google_service.push_notification_id
    provider        = Service.find_by_name(id.provider) if id
    payload         = google_service.get_user_messages if id
    
    OpenStruct.new({
      user: user,
      id: id,
      provider: provider,
      msg: payload,
    })
  end

  def mark_as_complete(msg)
    id = msg.user.identities.where(provider: 'google_oauth2').first
    msg_id = msg.message['google_id']
    service = GoogleService.new({id: id, msg_id: msg_id})
    service.mark_message_as_read
  end
  
end