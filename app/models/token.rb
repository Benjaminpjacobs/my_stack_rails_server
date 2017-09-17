class Token < SimpleDelegator

  def to_params
    { 'refresh_token' => refresh_token,
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
    update_attributes(
    token: data['access_token'],
    expires_at: Time.now + data['expires_in'].to_i.seconds
    )
  end
  
  def access_token
    refresh! if Time.at(expires_at) < Time.now
    token
  end
  
end

