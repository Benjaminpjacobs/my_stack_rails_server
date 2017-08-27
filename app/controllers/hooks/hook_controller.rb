class Hooks::HookController < ApplicationController
  def create
    conn = Faraday.new(:url => "https://api.github.com") 
    repos = conn.get do |req|
      req.url "/user/repos?type"
      req.headers['Authorization'] = "token #{current_user.token}"
      req.params['type'] = 'all'
      req.params['sort'] = 'updated'
      req.params['per_page'] = '100'
    end
    
    repo_list = JSON.parse(repos.body).map{|repo| repo['full_name']}
    
    repo_list.each do |repo|
      conn.post do |req|
        req.url "/repos/#{repo}/hooks"
        req.headers['Authorization'] = "token #{current_user.token}"
        req.body = '{
          "name": "web",
          "active": true,
          "events": [
            "push",
            "pull_request"
          ],
          "config": {
            "url": "https://f41cdce5.ngrok.io/hooks/github",
            "content_type": "json"
          }
          }'
        end
      end
    end
end