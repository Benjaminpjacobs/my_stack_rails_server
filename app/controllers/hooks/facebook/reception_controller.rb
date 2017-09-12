class Hooks::Facebook::ReceptionController < HookBaseController
  def received
    payload = JSON.parse(request.body.read)
    type = payload["entry"].first['changes'].first['field']
    msg = payload["entry"].first['changes'].first['value']
    id = Identity.find_by_uid(payload["entry"].first['uid'])
    user = id.user if id
        # user    = Identity.find_by_uid(payload["entry"]["uid"]).user
    # user.messages.create
    # Message.store(payload, user, event_type, 1)
  end
end
