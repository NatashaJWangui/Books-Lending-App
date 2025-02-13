class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email, :password))
      start_new_session_for user
      flash[:notice] = "Sign in successful."
      redirect_to session.delete(:return_to_after_authenticating) || dashboard_path
    else
      redirect_to sign_in_path, alert: "Try another email address or password."
    end
  end

  def destroy
    reset_session
    redirect_to sign_in_path, notice: "You have been logged out successfully."
  end
end
