class Hooks::Github::ReceptionController < HookBaseController
  def received
    event_type = request.headers["X-GitHub-Event"]
    payload    = JSON.parse(request.body.read)
    user       = User.find_by_uid(payload["sender"]["id"])
    if event_type == "issues" || event_type == "pull_request"
      Message.store(payload, user, event_type)
      service = WebsocketService.new
      service.post_message(user.id)
    else
      puts "New #{event_type} from GitHub"
    end
  end
end