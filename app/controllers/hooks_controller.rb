class HooksController < ApplicationController
  def index
    @hooks_presenter = HookPresenter.new(current_user)
  end
end