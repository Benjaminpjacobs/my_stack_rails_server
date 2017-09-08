class WebsocketService 
  def initialize
    @conn = Faraday.new(:url => 'https://my-stack-websocket.herokuapp.com/messages')
    # @conn = Faraday.new(:url => 'http://localhost:8080/messages')
  end

  def post_message(data)
    resp = @conn.post do |req|
      req.body = data
    end
  end
end