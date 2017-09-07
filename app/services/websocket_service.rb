class WebsocketService 
  def initialize
    @conn = Faraday.new(:url => 'https://my-stack-websocket.herokuapp.com/messages')
  end

  def post_message(data)
    resp = @conn.post do |req|
      req.body = {"msg": data}
    end
  end
end