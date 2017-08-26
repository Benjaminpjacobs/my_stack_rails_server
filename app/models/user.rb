class User < ApplicationRecord


  def self.from_omniauth(auth)
    binding.pry
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