class RegistrationsController < ApplicationController
    allow_unauthenticated_access only: [:new, :create]  # allow unauthenticated access for sign-up
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        start_new_session_for(@user) # Log in the new user
        flash[:notice] = "Signed up successfully!"
        redirect_to dashboard_path
      else
        flash[:alert] = @user.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end
  