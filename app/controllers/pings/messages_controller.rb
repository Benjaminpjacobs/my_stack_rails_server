class Pings::MessagesController < ActionController::Base
  def receive_ping
    user = User.find(params[:id])
    render json: user.messages.where(status: [0,1]).order(created_at: :desc), each_serializer: MessagesSerializer
  end

  def mark_read
    msg = Message.find(params[:msg_id])
    binding.pry
    if msg.service.name == 'google_oauth2' 
      id = msg.user.identities.where(provider: 'google_oauth2').first
      msg_id = msg.message['google_id']
      service = GoogleService.new({id: id, msg_id: msg_id})
      service.mark_message_as_read
    end

    msg.update_attributes(status: 2)
  end

  def clear_stack
    user = User.where(id: params[:id]).first
    user.messages.update_all(status: 2) if user
  end 
end