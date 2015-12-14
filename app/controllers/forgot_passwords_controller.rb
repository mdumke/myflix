class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user
      user.update_attribute(:token, SecureRandom.urlsafe_base64)
      UserMailer.delay.send_password_reset_link(user.id)
    end
    redirect_to confirm_forgot_password_path
  end
end

