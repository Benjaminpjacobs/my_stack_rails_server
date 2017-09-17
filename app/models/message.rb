class Message < ApplicationRecord
  store_accessor :message
  belongs_to :user
  belongs_to :service
  enum status: {received: 0, sent: 1, archived: 2}

  def self.github_format(payload, type, user, service)
    type = type.chomp('s') if type == "issues"
    {
      event_type: type,
      user_id: user.id,
      service_id: service.id,
      message: {
        action: payload['action'],
        url: payload[type]['html_url'],
        repo: payload['repository']['name'],
        title: payload[type]['title'],
        body: payload[type]['body'],
        state: payload[type]['state'],
        sender: payload[type]['user']['login'],
        created_at: payload[type]['created_at']
      }
      
    }
  end

  def self.google_format(message, type, user, service)
    subject_header = message.payload.headers.select{|header| header.name == "Subject"}
    subject = subject_header.empty? ? "(no subject)" : subject_header.first.value 
    from =  message.payload.headers.select{|header| header.name == "From" || header.name == "FROM"}.first.value
    parts = message.payload.parts
    {
      event_type: type,
      user_id: user.id,
      service_id: service.id,
      message: {
        google_id: message.id,
        subject: subject,
        from: from,
        snippet: message.snippet,
        full_message: parts ? parts.first.body.data : "(no data)"
      }
    }
  end

  def self.slack_format(data, message)
    {
      message: data, 
      event_type: 'message', 
      user_id: message.user.id, 
      service_id: message.provider.id
    }
    
  end
end