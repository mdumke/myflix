class UsersController < ApplicationController
  before_action :require_user, only: [:show]
  before_action :require_not_signed_in, only: [:forgot_password]
  before_action :set_user, only: [:show]

  # GET /register
  def new
    @user = User.new
  end

  def new_with_invitation_token
    @invitation = Invitation.find_by_token(params[:token])

    if @invitation
      @user = User.new(
        full_name: @invitation.recipient_name,
        email: @invitation.recipient_email)
      render 'new'
    else
      redirect_to invalid_token_path
    end
  end

  def show
    @videos = @user.queue_items.map(&:video)
    @reviews = @user.reviews
  end

  def create
    @user = User.new(user_params)

    if @user.save
      handle_invitation if params[:token]
      UserMailer.delay.welcome(@user.id)
      session[:user_id] = @user.id
      flash['notice'] = 'Account was successfully created'
      redirect_to videos_path
    else
      render 'new'
    end
  end

  private

  def handle_invitation
    invitation = Invitation.find_by_token(params[:token])
    inviter = invitation.inviter
    inviter.follow(@user)
    @user.follow(inviter)
    invitation.update_attributes(token: nil)
  end

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

