class PasswordResetsController < ApplicationController
  def show
    @user = User.find_by_token(params[:id])
    redirect_to invalid_token_path unless @user
  end

  def update
    user = User.find_by_token(params[:id])
    user.update_attributes(password: params[:password], token: nil) if user
    redirect_to login_path
  end
end

