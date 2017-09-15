class Hooks::Github::ReceptionController < ActionController::API
  include GithubHelper
  include SocketHelper

  def received
    event = objectify(request)

    if valid_event?(event.event_type) && format_and_save_message(event)
      ping_socket(event.user.id, event.provider.id)
    end
    
    render json: "ok", status: 200;
  end

  private

    def format_and_save_message(event)
      message = Message.github_format(event.payload, event.event_type, event.user, event.provider)
      Message.create(message)
    end

    def valid_event?(event_type)
      event_type == "issues" || event_type == "pull_request"
    end
end