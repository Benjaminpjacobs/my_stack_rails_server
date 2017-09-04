class MainController < ApplicationController
  def index
    @msg_url = ENV['MSG_URL']
    @socket_url = ENV['SOCKET_URL']
  end
end