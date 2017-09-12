class Hooks::Github::BroadcastController < ApplicationController
  before_action :set_token
  def new
    service = GithubService.new(@token)
    service.set_all_web_hooks
    id = current_user.identities.where(provider: 'github')
    id.first.update_attributes(hooks_set: true)
    redirect_to request.referer
  end 

  def delete
    service = GithubService.new(@token)
    service.delete_all_web_hooks
    id = current_user.identities.where(provider: 'github')
    id.first.update_attributes(hooks_set: false)
    redirect_to request.referer
  end

  def update
    service = GithubService.new(@token)
    service.reset_hooks
    redirect_to request.referer
  end

  private

    def repo_params
      params.require(:form_fields)
    end

    def set_token
      @token = current_user.identities.where(provider: 'github').first.token
    end
end