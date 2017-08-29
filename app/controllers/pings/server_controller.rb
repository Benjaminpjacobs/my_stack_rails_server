class Pings::ServerController < PingBaseController
  def receive_ping
    render json: {msg: 'We are all good in the hood'}
  end
end