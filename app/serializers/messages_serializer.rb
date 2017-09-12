class MessagesSerializer < ActiveModel::Serializer
  attributes :repo, :from, :link, :event_type, :id, :provider, :message_text, :message_sender, :snippet, :email_address, :subject

  def provider
    object.service.name
  end
  
  def message_sender
    eval(object.message['event'])['user'] if object.message['event']
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
  
  def snippet
    object.message['snippet']
  end

  def email_address
    object.message['from'].split('<').first if object.message['from']
  end

  def subject
    object.message['subject']
  end
end
