class Hooks::Facebook::ReceptionController < HookBaseController
  include FacebookHelper
  include SocketHelper

  def received
    payload = JSON.parse(request.body.read)
    object = objectify(payload)
    message = Message.new(object)

    if valid_message?(object) && message.save
      binding.pry
      ping_socket(message.user_id, message.service_id)
    end
    render json: {"msg": "ok"}, status: 200;
  end
  
  def challenge
    render status: 200, json: params['hub.challenge']
  end

  private

    def valid_message?(message)
      msg_id = message[:message]['id']
      Message.where("message @> 'id=>#{msg_id}'").empty?
    end
end
