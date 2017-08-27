class Hooks::GithubController < HookBaseController
  def received
    push = JSON.parse(request.body.read)
    puts "I got some JSON: #{push.inspect}"
  end
end