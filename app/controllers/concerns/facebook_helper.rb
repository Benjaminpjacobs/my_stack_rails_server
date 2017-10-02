module FacebookHelper
  extend ActiveSupport::Concern
  def objectify(payload)
    uid       = payload['entry'].first['uid']
    id        = Identity.find_by_uid(uid)
    user      = id.user
    facebook  = Koala::Facebook::API.new(id.token)
    message   = facebook.get_object("me/feed").first
    provider  = Service.find_by_name('facebook')

    {
      user_id: user.id,
      message: message,
      event_type: 'feed',
      service_id: provider.id,
    }
    
  end
end