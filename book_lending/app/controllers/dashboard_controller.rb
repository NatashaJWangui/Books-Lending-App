class DashboardController < ApplicationController
  before_action :require_login

  def index
  end

  private

  def require_login
    redirect_to new_session_path, alert: "Please log in to continue." unless current_user
  end
end
