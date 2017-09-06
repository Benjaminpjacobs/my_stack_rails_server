class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:github, :google_oauth2]
  
  # validates :email, presence: :true, uniqueness: :true
  # validates :provider, presence: :true
  # validates :token, presence: :true
  # validates :uid, presence: :true
  # validates :username, presence: :true
  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update
  has_many :identities, dependent: :destroy 
  has_many :messages, dependent: :destroy
  has_many :users_services, dependent: :destroy
  has_many :services, through: :users_services
  
  def self.find_for_oauth(auth, signed_in_resource = nil)
      # Get the identity and user if they exist
      identity = Identity.find_for_oauth(auth)
  
      # If a signed_in_resource is provided it always overrides the existing user
      # to prevent the identity being locked with accidentally created accounts.
      # Note that this may leave zombie accounts (with no associated identity) which
      # can be cleaned up at a later date.
      user = signed_in_resource ? signed_in_resource : identity.user
  
      # Create the user if needed
      if user.nil?
  
        # Get the existing user by email if the provider gives us a verified email.
        # If no verified email was provided we assign a temporary email and ask the
        # user to verify it on the next step via UsersController.finish_signup
        # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email #if email_is_verified
        user = User.where(:email => email).first if email
  
        # Create the user if it's a new registration
        if user.nil?
          user = User.new(
            name: auth.extra.raw_info.name,
            #username: auth.info.nickname || auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20]
          )
          user.save!

        end
      end
  
      # Associate the identity with the user if needed
      if identity.user != user
        identity.user = user
        identity.save!
      end
      user
    end
  
    def email_verified?
      self.email && self.email !~ TEMP_EMAIL_REGEX
    end
  end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  #     user.email = auth.info.email
  #     user.username = auth.info.nickname
  #     user.uid = auth.uid
  #     user.provider = auth.provider
  #     user.token = auth.credentials.token
  #     user.save!
  #   end
  # end

