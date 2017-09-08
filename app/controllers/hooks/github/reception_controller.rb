class Hooks::Github::ReceptionController < HookBaseController
  def received
    event_type = request.headers["X-GitHub-Event"]
    payload    = JSON.parse(request.body.read)
    user       = Identity.find_by_uid(payload["sender"]["id"]).user

    if event_type == "issues" || event_type == "pull_request"
      Message.store(payload, user, event_type, 1)
      service = WebsocketService.new
      service.post_message({user_id: user.id, service_id: 1})
    else
      render status: 200;
    end
  end
end