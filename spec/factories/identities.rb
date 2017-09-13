FactoryGirl.define do
  factory :identity do
    user
    provider "Github"
    uid "123456"
    token "ASDF1234"
    refresh_token "1234ASDF"
    expires_at Time.now.to_i + 3600
    hooks_set false
    hooks_expire nil
    hook_expires_at nil
  end
end
