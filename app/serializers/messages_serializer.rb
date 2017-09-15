class MessagesSerializer < ActiveModel::Serializer
  attributes :repo, :from, :link, :event_type, :id, :provider, :message_text, :message_sender, :snippet, :email_address, :subject, :title, :body

  def provider
    object.service.name
  end
  
  def message_sender
    object.message['user']
  end

  def message_text
    object.message['text']
  end

  def repo
    object.message['repo']
  end
  
  def title
    object.message['title']
  end

  def body
    object.message['body']
  end

  def from
    object.message["sender"]
  end

  def link
    object.message["url"]
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
