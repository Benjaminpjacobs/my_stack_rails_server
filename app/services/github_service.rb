class GithubService
  def initialize(token)
    @conn = Faraday.new(:url => "https://api.github.com")
    @token = token 
  end

  def get_repos
    @response ||= @conn.get do |req|
      req.url "/user/repos?type"
      req.headers['Authorization'] = "token #{@token}"
      req.params['type'] = 'all'
      req.params['sort'] = 'updated'
      req.params['per_page'] = '100'
    end
  end

  def repo_list
    @repo_list ||= JSON.parse(get_repos.body).map{|repo| repo['full_name']}
  end

  def reset_hooks
    delete_all_web_hooks
    set_all_web_hooks  
  end

  def set_all_web_hooks
    repo_list.each do |repo|
      set_web_hook(repo)
    end
  end

  def set_web_hook(repo)
    @conn.post do |req|
      req.url "/repos/#{repo}/hooks"
      req.headers['Authorization'] = "token #{@token}"
      req.body = JSON.generate({"name": "web", "active": true, "events": ["issues", "pull_request"],"config": {"url": "#{ENV["GITHUB_WEBHOOK_URL"]}","content_type": "json"}})
    end
  end
  

  def delete_web_hook(repo, id)
    @conn.delete do |req|
      req.url "/repos/#{repo}/hooks/#{id}"
      req.headers['Authorization'] = "token #{@token}"
    end
  end
  
  def delete_all_web_hooks
    hook_list.each do |repo, hook|
      delete_web_hook(repo, hook.first['id']) if hook.first && !hook.first.include?('Not Found')
    end
  end

  def hook_list
    @hook_list ||= repo_list.map do |repo|
      resp = get_hook(repo)
      body = JSON.parse(resp.body)
      {repo => body}
    end.reduce({}, :merge)
  end

  def get_hook(repo)
    @conn.get do |req|
      req.url "/repos/#{repo}/hooks"
      req.headers['Authorization'] = "token #{@token}"
    end
  end
end