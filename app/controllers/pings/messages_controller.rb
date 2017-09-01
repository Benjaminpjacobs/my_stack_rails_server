class Pings::MessagesController < PingBaseController
  def receive_ping
    user = User.find(params[:id])
    render json: user.messages.where(status: [0,1]), each_serializer: MessagesSerializer
  end
end