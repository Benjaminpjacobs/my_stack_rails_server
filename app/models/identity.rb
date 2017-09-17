class Identity < ApplicationRecord
  belongs_to :user
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider

  def self.find_for_oauth(auth)
    id = find_or_create_by(uid: auth.uid, provider: auth.provider)
    id.tap do |i|
      if auth.credentials
        i.token = auth.credentials.token 
        i.refresh_token = auth.credentials.refresh_token 
        i.expires_at = auth.credentials.expires_at 
      end
      i.save! unless i.new_record?
    end
  end
end
