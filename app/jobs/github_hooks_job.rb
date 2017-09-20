class GithubHooksJob < ApplicationJob
  queue_as :default

  def perform(token, action)
    @service = GithubService.new(token)
    @service.send(action.to_sym)
  end
end
