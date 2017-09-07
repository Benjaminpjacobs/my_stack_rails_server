class Hooks::Slack::ReceptionController < HookBaseController
  def received
    payload    = JSON.parse(request.body.read)
    user = Identity.find_by_uid(payload['event']['user']).user
    if user
      Message.store(payload, user, 'message', 2)
      # service = WebsocketService.new
      # service.post_message(user.id)
    else
      puts "New message from Slack"
    end
  end
end