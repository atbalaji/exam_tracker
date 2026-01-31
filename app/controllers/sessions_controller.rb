class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid credentials"
      render :new
    end
  end

  def destroy
    reset_session # safer alternative for (session[:user_id] = nil) clears entire session
    redirect_to login_path
  end
end
