class User < ApplicationRecord
  validates :email, presence: :true, uniqueness: :true
  validates :provider, presence: :true
  validates :token, presence: :true
  validates :uid, presence: :true
  validates :username, presence: :true


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.username = auth.info.nickname
      user.uid = auth.uid
      user.provider = auth.provider
      user.token = auth.credentials.token
      user.save!
    end
  end
end