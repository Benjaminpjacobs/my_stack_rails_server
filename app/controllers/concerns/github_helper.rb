module GithubHelper
  extend ActiveSupport::Concern

  def objectify(request)
    event_type = request.headers["X-GitHub-Event"]
    payload    = JSON.parse(request.body.read)
    user       = Identity.find_by_uid(payload["sender"]["id"]).user
    provider   = Service.find_by_name('github')
    
    OpenStruct.new({
      event_type: event_type,
      payload: payload,
      user: user,
      provider: provider,
    })
  end
end