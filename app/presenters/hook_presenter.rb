class HookPresenter
  def initialize(user)
    @user = user
  end
  def github
    @gh_id ||= @user.identities.find_by_provider('github')
  end

  def github_hooks_set?
    github.hooks_set
  end

  def google
    @google_id ||= @user.identities.find_by_provider('google_oauth2')
  end

  def google_hooks_set?
    google.hooks_set
  end

  def slack
    @slack_id ||= @user.identities.find_by_provider('slack')
  end

  def slack_hooks_set?
    slack.hooks_set
  end

end