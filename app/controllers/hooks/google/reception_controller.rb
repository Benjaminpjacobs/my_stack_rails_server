class Hooks::Google::ReceptionController < HookBaseController
  include SocketHelper

  def received
    google_service  = GoogleService.new({request: request})
    user            = google_service.push_notification_email
    id              = google_service.push_notification_id
    provider        = Service.find_by_name(id.provider) if id
    msg             = google_service.get_user_messages if id
    
    if valid_message?(msg)
      ping_socket(user.id, provider.id) if format_and_save_message(msg,user,provider)
    end
    
    render json: {"msg": "ok"}, status: 200;
  end
  
  private
  
    def valid_message?(msg)
      msg && 
      msg.label_ids.include?('UNREAD') && 
      msg.label_ids.include?('INBOX') && 
      !msg.label_ids.include?('CATEGORY_PROMOTIONS') && 
      new_message?(msg.id)
    end
  
    def format_and_save_message(msg,user,provider)
      message = Message.google_format(msg, 'message', user, provider )
      Message.create(message)
    end

    def new_message?(id)
      Message.where("message @> 'google_id=>#{id}'").empty?
    end
end