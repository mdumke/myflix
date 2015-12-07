require 'spec_helper'

feature 'user resets their password' do
  scenario 'as regular email-procedure' do
    alice = Fabricate(:user)
    clear_emails

    visit login_path
    click_link 'forgot password?'

    request_password_reset_link(alice)
    expect(page).to have_content('We have send an email')

    follow_reset_link_in_email(alice)
    expect(page).to have_content('Reset Your Password')

    fill_in 'New Password', with: '123'
    click_button 'Reset Password'

    login_with_new_password(alice, '123')
    expect(page).to have_content(alice.full_name)
  end

  def request_password_reset_link(user)
    fill_in 'Email Address', with: user.email
    click_button 'Send Email'
  end

  def follow_reset_link_in_email(user)
    open_email(user.email)
    current_email.click_link(reset_password_form_url(user.reload.token))
  end

  def login_with_new_password(user, password)
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: password
    click_button 'Sign In'
  end
end

