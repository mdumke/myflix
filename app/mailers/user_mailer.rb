class UserMailer < ActionMailer::Base
  def welcome(user)
    @user = user

    mail to: user.email,
         from: 'support@myflix.com',
         subject: 'Welcome to MyFlix'
  end
end

