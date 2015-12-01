class SessionsController < ApplicationController
  before_action :require_not_signed_in, only: [:front, :new]

  def front
  end

  # GET /login
  def new
  end

  # POST /login
  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      user.update_attribute(:token, nil)
      flash['notice'] = 'Successfully signed in'
      redirect_to videos_path
    else
      flash.now['error'] = 'Invalid email or password'
      render 'new'
    end
  end

  # GET /logout
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully signed out'
  end
end

