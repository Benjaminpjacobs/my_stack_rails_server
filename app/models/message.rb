class Message < ApplicationRecord
  store_accessor :message
  belongs_to :user
  enum status: {received: 0, sent: 1, archived: 0}

  def self.store(push, user, type)
    user.messages.create(message: push, event_type: type)
  end
end