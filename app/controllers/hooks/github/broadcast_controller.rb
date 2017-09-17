class Hooks::Github::BroadcastController < ApplicationController
  before_action :set_token
  before_action :set_github_service
  before_action :set_id, only: [:new, :delete]
  
  def new
    @service.set_all_web_hooks
    update_id(true)
    redirect_to request.referer
  end 

  def delete
    
    @service.delete_all_web_hooks
    update_id(false)
    redirect_to request.referer
  end

  def update
    @service.reset_hooks
    redirect_to request.referer
  end

  private
    def update_id(bool)
      @id.first.update_attributes(hooks_set: bool)
    end

    def set_id
      @id = current_user.identities.where(provider: 'github')
    end
    
    def set_github_service
      @service = GithubService.new(@token)
    end
    
    def repo_params
      params.require(:form_fields)
    end

    def set_token
      @token = current_user.identities.where(provider: 'github').first.token
    end
end