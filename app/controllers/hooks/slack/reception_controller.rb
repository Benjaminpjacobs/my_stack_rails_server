class Hooks::Slack::ReceptionController < HookBaseController
  include SlackHelper
  include SocketHelper

  def received
    payload    = JSON.parse(request.body.read)
    return render json: payload['challenge'] if payload['challenge']
    message    = objectify(payload)

    if valid_message?(message) && format_and_save(message, payload)
      ping_socket(message.user.id, message.provider.id)
    end

    render json: "ok" , status: 200

  end

  private

    def format_and_save(msg, payload)
      data = add_user_to_payload(msg.token, msg.from_user_id, payload)
      message = Message.slack_format(data, msg)
      Message.create(message)
    end
  
    def new_message?(event_id)
      Message.where("message @> 'event_id=>#{event_id}'").empty?
    end

    def valid_message?(message)
      message.user && message.token && new_message?(message.event_id)
    end

end