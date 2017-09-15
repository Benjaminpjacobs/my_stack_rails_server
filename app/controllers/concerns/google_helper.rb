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
  
end