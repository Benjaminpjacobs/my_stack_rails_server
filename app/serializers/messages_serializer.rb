class MessagesSerializer < ActiveModel::Serializer
  attributes :repo, :from, :link, :event_type, :id, :provider, :message_text, :message_sender

  def provider
    object.service.name
  end
  
  def message_sender
    from_user = eval(object.message['event'])['user'] if object.message['event']
    to_user = eval(object.message['authed_users']).first if object.message['authed_users']
    id = Identity.find_by_uid(to_user)
    token = id.token if id
    if token
      service = SlackService.new(token)
      user_info = service.get_user_name(from_user)
      user_info['user']['name'] if user_info['user']
    end
  end

  def message_text
    eval(object.message['event'])['text'] if object.message['event']
  end

  def repo
    eval(object.message["repository"])["name"] if object.message["repository"]
  end

  def from
    eval(object.message["sender"])["login"] if object.message["sender"]
  end

  def link
    eval(object.message["pull_request"])["html_url"] if object.message["pull_request"]
  end

  def event_type
    object.event_type.split('_').map{|word| word.capitalize}.join(' ')
  end
end
