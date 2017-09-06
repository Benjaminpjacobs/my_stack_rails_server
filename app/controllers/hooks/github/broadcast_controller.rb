class Hooks::Github::BroadcastController < ApplicationController
  before_action :set_token
  def new
    service = GithubService.new(@token)
    @repos = JSON.parse(service.get_repos.body)
  end 

  def edit
    service = GithubService.new(@token)
    @repos = JSON.parse(service.get_repos.body)
  end 

  def create
    service = GithubService.new(@token)
    repos = repo_params.select{|k, v| v == '1'}.keys
    
    provider = Service.find_by_name('github')
    current_user.services << provider unless current_user.services.include?(provider)
    
    repos.each do |repo|
      service.set_web_hook(repo)
    end
    
    redirect_to root_path
  end

  def delete
    service = GithubService.new(@token)
    repos = repo_params.select{|k, v| v == '1'}.keys
    
    repos.each do |repo|
      hook = service.get_hook(repo)
      id = JSON.parse(hook.body).first['id']
      service.delete_web_hook(repo, id)
    end
    redirect_to root_path
  end
  private
    def repo_params
      params.require(:form_fields)
    end

    def set_token
      @token = current_user.identities.where(provider: 'github').first.token
    end
end