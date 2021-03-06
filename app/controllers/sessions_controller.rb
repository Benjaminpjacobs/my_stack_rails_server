class SessionsController < ApplicationController
  def new
    redirect_to hooks_path if current_user
  end
  
  def create
    user = User.find_for_oauth(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id
      redirect_to hooks_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end