class Hooks::Slack::ReceptionController < HookBaseController
  def received
    payload    = JSON.parse(request.body.read)
    msg_token = payload['token']
    id = Identity.find_by_uid(payload['event']['user']) if payload['event']
    user = id.user if id
    if user
      Message.store(payload, user, 'message', 2)
      service = WebsocketService.new
      service.post_message(user.id)
    else
      binding.pry
      render json: payload['challenge'] || "ok" , status: 200
    end
  end

  def new_message?(msg_token)
    Message.where("message @> 'token=>#{msg_token}'").empty?
  end
end