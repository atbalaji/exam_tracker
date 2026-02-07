class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    @user = User.new(signup_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Signed Up successfully."
      redirect_to root_path
    else
      flash[:alert] = "Sign up failed."
      render :new
    end
  end

  private

  def signup_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end
