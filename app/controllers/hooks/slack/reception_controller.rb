class Hooks::Slack::ReceptionController < HookBaseController
  include SlackHelper
  include SocketHelper

  def received
    payload    = JSON.parse(request.body.read)
    return render json: payload['challenge'] if payload['challenge']
    
    parsed     = parse_payload(payload)

    if valid_message?(parsed)
      data = add_user_to_payload(parsed.token, parsed.from_user_id, payload)
      Message.create(
                     message: data, 
                     event_type: 'message', 
                     user_id: parsed.user.id, 
                     service_id: parsed.provider.id
                     )
      ping_socket(parsed.user.id, parsed.provider.id)
    end

    render json: "ok" , status: 200

  end

  private
  
    def new_message?(event_id)
      Message.where("message @> 'event_id=>#{event_id}'").empty?
    end

    def valid_message?(parsed)
      parsed.user && parsed.token && new_message?(parsed.event_id)
    end

end