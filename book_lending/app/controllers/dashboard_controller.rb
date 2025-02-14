class DashboardController < ApplicationController
  before_action :require_login

  def index
  end

  private

  def require_login
    unless current_user
      flash[:alert] = "Please log in to continue."
      flash.keep # Ensures flash persists across redirects
      redirect_to sign_in_path
    end
  end
end
