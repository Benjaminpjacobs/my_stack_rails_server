class Service <ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :users_services
  has_many :users, through: :users_services
end