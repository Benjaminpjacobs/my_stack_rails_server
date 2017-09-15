class Service <ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :messages
end