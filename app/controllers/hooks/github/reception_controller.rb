class Hooks::Github::ReceptionController < HookBaseController
  def received
    event_type = request.headers["X-GitHub-Event"]
    payload = JSON.parse(request.body.read)
    user = User.find_by_uid(payload["sender"]["id"])
    # payload    = JSON.parse(request.body)
    binding.pry
    case event_type
    when "repository"
      # process_repository(payload)
    when "issues"
      # process_issue(payload)
    when "pull_request"
      # process_pull_requests(payload)
    else
      puts "Oooh, something new from GitHub: #{event_type}"
    end

    # Message.store(push, user)
    # service = WebsocketService.new
    # service.post_message(user.id)
  end
end