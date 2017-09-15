module SocketHelper
  extend ActiveSupport::Concern

  def ping_socket(user, provider)
    socket = WebsocketService.new
    socket.post_message({user_id: user, service_id: provider})
  end
end