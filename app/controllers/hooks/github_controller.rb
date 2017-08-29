class Hooks::GithubController < HookBaseController
  def received
    push = JSON.parse(request.body.read)
    # puts "I got some JSON: #{push.inspect}"
    msg = push["zen"]
    service = WebsocketService.new
    service.post_message(msg)
  end
end