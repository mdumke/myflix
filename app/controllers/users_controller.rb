class UsersController < ApplicationController
  before_action :require_user, only: [:show]
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

  def set_user
    @user = User.find_by_id(params[:id])

    unless @user
      flash[:error] = 'This user does not exist'
      redirect_to home_path
    end
  end
end

