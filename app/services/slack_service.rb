class SlackService
  attr_reader :token
  def initialize(token)
    @conn = Faraday.new(:url => "https://slack.com/api/")
    @token = token 
  end

  def get_user_name(user)
    resp = @conn.get "users.info?token=#{@token}&user=#{user}"
    JSON.parse(resp.body)
  end
end