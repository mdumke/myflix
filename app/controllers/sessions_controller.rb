class SessionsController < ApplicationController
  def front
    redirect_to home_path if current_user
  end
  
  # GET /login
  def new
    redirect_to home_path if current_user
  end

  # POST /login
  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
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

