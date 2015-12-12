require 'spec_helper'

feature 'user can invite other users' do
  background { default_url_options[:host] = 'localhost:3000' }

  scenario 'successful invitation' do
    alice = Fabricate(:user)
    clear_emails

    sign_in(alice)
    visit new_invitation_path
    fill_in "Friend's Name", with: 'Mira Belle'
    fill_in "Friend's Email Address", with: 'some@one.com'
    fill_in "Invitation Message", with: 'Join the army'
    click_button 'Send Invitation'
    expect(page).to have_content('Your invitation has been sent')

    open_email('some@one.com')
    current_email.click_link('Accept this invitation')
    expect(page).to have_content('Register')

    fill_in 'Password', with: '123'
    click_button 'Sign Up'
    expect(page).to have_content('Account was successfully created')

    visit people_path
    expect(page).to have_content(alice.full_name)
  end
end
