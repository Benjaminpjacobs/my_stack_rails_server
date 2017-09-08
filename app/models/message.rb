class Message < ApplicationRecord
  store_accessor :message
  belongs_to :user
  belongs_to :service
  enum status: {received: 0, sent: 1, archived: 2}

  def self.store(push, user, type, service_id)
    user.messages.create(message: push, event_type: type, service_id: service_id)
  end
end