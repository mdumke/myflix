class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :require_not_signed_in, only: [:forgot_password]
  before_action :set_user, only: [:show]

  # GET /register
  def new
    @user = User.new
  end

  def show
    @videos = @user.queue_items.map(&:video)
    @reviews = @user.reviews
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome(@user).deliver
      session[:user_id] = @user.id
      flash['notice'] = 'Account was successfully created'
      redirect_to videos_path
    else
      render 'new'
    end
  end

  def forgot_password
  end

  def send_password_reset_link
    user = User.find_by_email(params[:email])
    if user
      user.update_attribute(:token, SecureRandom.urlsafe_base64)
      UserMailer.send_password_reset_link(user).deliver
    end
    redirect_to confirm_password_reset_path
  end

  def confirm_password_reset
  end

  def reset_password_form
    @user = User.find_by_token(params[:id])

    unless @user
      redirect_to invalid_token_path
    end
  end

  def reset_password
    user = User.find_by_token(params[:token])
    user.update_attributes(password: params[:password], token: nil) if user
    redirect_to login_path
  end

  def invalid_token
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end

  def set_user
    @user = User.find_by_id(params[:id])

    unless @user
      flash[:error] = 'This user does not exist'
      redirect_to home_path
    end
  end
end

