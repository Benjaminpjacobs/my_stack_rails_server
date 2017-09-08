class Hooks::Slack::ReceptionController < HookBaseController
  def received
    # payload    = JSON.parse(request.body.read)
    # msg_token = payload['token']
    # from_user_id = payload['event']['user']
    # id = Identity.find_by_uid(payload['authed_users'].first) if payload['authed_users']
    # token = id.token if id
    # user = id.user if id

    # if token
    #   service = SlackService.new(token)
    #   user_info = service.get_user_name(from_user_id)
    #   payload['event']['user'] = user_info['user']['name'] if user_info['user']
    # end
    
    # if user
    #   Message.store(payload, user, 'message', 2)
    #   service = WebsocketService.new
    #   service.post_message({user_id: user.id, service_id: 2})
    # else
      render json: payload['challenge'] || "ok" , status: 200
    # end

  end

  def new_message?(msg_token)
    Message.where("message @> 'token=>#{msg_token}'").empty?
  end

  def get_sender

  end
end