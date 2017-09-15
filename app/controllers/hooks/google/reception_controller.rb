class Hooks::Google::ReceptionController < HookBaseController
  include GoogleHelper
  include SocketHelper

  def received
    message = objectify(request)
    
    if valid_message?(message.msg) && format_and_save_message(message.msg, message.user, message.provider)
      ping_socket(message.user.id, message.provider.id)
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