class Hooks::Slack::BroadcastController < ApplicationController
  def delete
    current_user.identities.where(provider: 'slack').first.destroy
    redirect_to request.referer
  end
end