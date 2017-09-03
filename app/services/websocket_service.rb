class WebsocketService 
  def initialize
    @conn = Faraday.new(:url => "http://localhost:8080/messages")
  end

  def post_message(data)
    binding.pry
    resp = @conn.post do |req|
      req.body = {"msg": data}
    end
    # puts resp
  end
end