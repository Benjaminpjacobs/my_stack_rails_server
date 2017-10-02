class Hooks::Facebook::ReceptionController < HookBaseController
  def received
    payload = JSON.parse(request.body.read)
    user = 
    payload["entry"].each do |entry|

    end
    binding.pry
  end
  
  def challenge
    render status: 200, json: params['hub.challenge']
  end
end
