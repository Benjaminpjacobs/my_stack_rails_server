class Hooks::Slack::ReceptionController < HookBaseController
  def received
    payload    = JSON.parse(request.body.read)
    msg_token = payload['token']
    from_user_id = payload['event']['user']
    id = Identity.find_by_uid(payload['authed_users'].first) if payload['authed_users']
    provider = Service.find_by_name('slack')
    token = id.token if id
    user = id.user if id
    
    if token
      service = SlackService.new(token)
      user_info = service.get_user_name(from_user_id)
      payload['event']['user'] = user_info['user']['name'] if user_info['user']
    end
    
    if user
      data = payload.extract!('event')['event'].merge!(payload)
      Message.create(message: data, event_type: 'message', user_id: user.id, service_id: provider.id)
      socket = WebsocketService.new
      socket.post_message({user_id: user.id, service_id: provider.id})
    end
    render json: payload['challenge'] || "ok" , status: 200

  end

  def new_message?(msg_token)
    Message.where("message @> 'token=>#{msg_token}'").empty?
  end

  def get_sender

  end
end