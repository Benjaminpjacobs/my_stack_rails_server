class Pings::MessagesController < ActionController::Base
  def receive_ping
    user = User.find(params[:id])
    render json: user.messages.where(status: [0,1]).order(created_at: :desc), each_serializer: MessagesSerializer
  end

  def mark_read
    msg = Message.find(params[:msg_id])
    msg.update_attributes(status: 2)
  end

  def clear_stack
    current_user.messages.update_all(status: 2)
    service = WebsocketService.new
    service.post_message({user_id: current_user.id, service_id: nil})
  end
end