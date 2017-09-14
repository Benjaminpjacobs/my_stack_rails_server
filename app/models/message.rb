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

end