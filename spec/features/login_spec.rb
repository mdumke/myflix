require 'spec_helper'

feature 'login process' do
  scenario 'signing in as an existing user' do
    user = Fabricate(:user)
    visit login_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
    expect(page).to have_content user.full_name
  end
end

