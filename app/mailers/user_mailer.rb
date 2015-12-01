class UserMailer < ActionMailer::Base
  def welcome(user)
    @user = user

    mail to: user.email,
         from: 'support@myflix.com',
         subject: 'Welcome to MyFlix'
  end

  def send_password_reset_link(user)
    @user = user

    mail to: user.email,
         from: 'support@myflix.com',
         subject: 'password reset'
  end
end

