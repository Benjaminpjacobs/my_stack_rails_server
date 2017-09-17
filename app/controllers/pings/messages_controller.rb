class Pings::MessagesController < ActionController::Base
  include GoogleHelper
  def receive_ping
    user = User.find(params[:id])
    render json: user.messages.where(status: [0,1]).order(created_at: :desc), each_serializer: MessagesSerializer
  end

  def mark_read
    msg = Message.find(params[:msg_id])
    mark_as_complete(msg) if msg.service.name == 'google_oauth2' 
    msg.update_attributes(status: 2)
  end

  def clear_stack
    user = User.where(id: params[:id]).first
    user.messages.update_all(status: 2) if user
  end 
end