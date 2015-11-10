require 'spec_helper'

feature 'login process' do
  scenario 'signing in as an existing user' do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content user.full_name
  end
end

