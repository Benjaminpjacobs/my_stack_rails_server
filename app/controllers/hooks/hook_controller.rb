class Hooks::HookController < ApplicationController
  def create
    username = User.first.username
    token = User.first.token
    conn = Faraday.new(:url => "https://api.github.com") 
    resp = conn.post do |req|
      req.url "/repos/#{current_user.username}/2DoBox-Pivot/hooks"
      req.headers['Authorization'] = "token #{current_user.token}"
      req.body = '{
        "name": "web",
        "active": true,
        "events": [
          "push",
          "pull_request"
        ],
        "config": {
          "url": "https://4024f579.ngrok.io/hooks/github",
          "content_type": "json"
        }
        }'
      end
    end
end