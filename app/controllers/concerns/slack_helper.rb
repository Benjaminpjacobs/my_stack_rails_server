module SlackHelper
  extend ActiveSupport::Concern
  
  def parse_payload(payload)
    event_id = payload['event_id']
    from_user_id = payload['event']['user']
    id = Identity.find_by_uid(payload['authed_users'].first) if payload['authed_users']
    provider = Service.find_by_name('slack')
    token, user = id.token, id.user if id

    OpenStruct.new({
      event_id: event_id, 
      from_user_id: from_user_id, 
      id: id, 
      provider: provider, 
      token: token, 
      user: user
    })
  end

  def add_user_to_payload(token, user_id, payload)
    service = SlackService.new(token)
    user_info = service.get_user_name(user_id)
    payload['event']['user'] = user_info['user']['name'] if user_info['user']
    payload.extract!('event')['event'].merge!(payload)
  end
end