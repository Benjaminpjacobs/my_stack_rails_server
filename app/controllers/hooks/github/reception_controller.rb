class Hooks::Github::ReceptionController < ActionController::API
  def received
    event_type = request.headers["X-GitHub-Event"]
    payload    = JSON.parse(request.body.read)
    user       = Identity.find_by_uid(payload["sender"]["id"]).user
    provider   = Service.find_by_name('github')

    if event_type == "issues" || event_type == "pull_request"
      message = Message.github_format(payload, event_type, user, provider)
      Message.create(message)
      socket = WebsocketService.new
      socket.post_message({user_id: user.id, service_id: provider.id})
    end
    
    render json: {"msg": "ok"}, status: 200;
  end
end