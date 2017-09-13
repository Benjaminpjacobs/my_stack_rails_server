class HooksController < ApplicationController
  before_action :validate_user
  
  def index
    @hooks_presenter = HookPresenter.new(current_user)
  end
  
  private

  def validate_user
    redirect_to root_path unless current_user
  end
end