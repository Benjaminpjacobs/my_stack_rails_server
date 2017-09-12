class Token
  def initialize(identity)
    @id = identity
  end
  
  def to_params
    { 'refresh_token' => @id.refresh_token,
      'client_id'     => ENV['GOOGLE_ID'],
      'client_secret' => ENV['GOOGLE_SECRET'],
      'grant_type'    => 'refresh_token'}
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    data = JSON.parse(request_token_from_google.body)
    binding.pry
    @id.update_attributes(
      token: data['access_token'],
      expires_at: Time.now + data['expires_in'].to_i.seconds
    )
  end
  
  def access_token
    t = @id.token
    refresh! if Time.at(@id.expires_at) < Time.now
    @id.token
  end
end

