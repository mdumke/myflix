class UserMailer < ActionMailer::Base
  def welcome(user_id)
    @user = User.find(user_id)

    mail to: @user.email,
         from: 'support@myflix.com',
         subject: 'Welcome to MyFlix'
  end

  def send_password_reset_link(user_id)
    @user = User.find(user_id)

    mail to: @user.email,
         from: 'support@myflix.com',
         subject: 'password reset'
  end

  def send_invitation(invitation_id)
    @invitation = Invitation.find(invitation_id)

    mail to: @invitation.recipient_email,
         from: 'support@myflix.com',
         subject: 'Invitation to join MyFlix'
  end
end

