class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:github, :google_oauth2, :slack, :facebook, :twitter]
  

  validates :email, uniqueness: :true
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  has_many :identities, dependent: :destroy 
  has_many :messages, dependent: :destroy
  
  def self.find_for_oauth(auth, signed_in_resource = nil)
      identity = Identity.find_for_oauth(auth)
      user = signed_in_resource ? signed_in_resource : identity.user

      if user.nil?
        email = auth.info.email 
        user = User.where(:email => email).first if email
      
        if user.nil?
          user = User.create!(
            name: auth.extra.raw_info.name,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
          )
        end
      end
      
      if identity.user != user
        identity.user = user
        identity.save!
      end
      
      user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def services
    identities.pluck(:provider)
  end
end



