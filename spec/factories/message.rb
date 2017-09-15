FactoryGirl.define do
  factory :message do
    user
    status 0
    service

    factory :google_message do
      message { 
                  { 
                    "data"=>"This is some data",                   
                    "from"=>"joe@example.com", 
                    "snippet"=>"This is..." 
                  } 
                }
      event_type "message"
    end

    factory :slack_message do
      message {
        {"ts"=>"1505410202.000148",
        "text"=>"testing!",
        "type"=>"event_callback",
        "user"=>"benjaminpjacobs",
        "token"=>"Clw9JQXt0MXA7dLHTeZDja1y",
        "channel"=>"C710SJY79",
        "team_id"=>"T7025KXGD",
        "event_id"=>"Ev73ABH76G",
        "event_ts"=>"1505410202.000148",
        "api_app_id"=>"A6ZK8PV33",
        "event_time"=>"1505410202",
        "authed_users"=>"[\"U70Q8ND1U\"]"}
                }
      event_type "message"
    end

    factory :github_pull_request do
      message {
        {"url"=>"https://github.com/Benjaminpjacobs/word_watch/pull/3",
        "body"=>"",
        "repo"=>"word_watch",
        "state"=>"open",
        "title"=>"Update README.md",
        "action"=>"opened",
        "sender"=>"Benjaminpjacobs",
        "created_at"=>"2017-09-13T17:06:23Z"}
              }
      event_type "pull_request"
    end

    factory :github_issue do
      message{
        {"url"=>"https://github.com/Benjaminpjacobs/my_stack_rails_server/issues/5",
        "body"=>nil,
        "repo"=>"my_stack_rails_server",
        "state"=>"closed",
        "title"=>"Simplify github settings pages with option to simply set hooks on new repos",
        "action"=>"unlabeled",
        "sender"=>"Benjaminpjacobs",
        "created_at"=>"2017-09-06T14:12:23Z"}
            }
      event_type 'issues'
    end
  end

  
end