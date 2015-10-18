class UsersController < ApplicationController
  # GET /register
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save 
      session[:user_id] = @user.id
      flash['notice'] = 'Account was successfully created'
      redirect_to videos_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end
end

