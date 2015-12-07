require 'spec_helper'

describe ForgotPasswordsController do
  describe 'GET new' do
    it 'renders the new view for the forgot password page' do
      get :new
      expect(response).to render_template 'new'
    end
  end

  describe 'POST create' do
    let!(:alice) { Fabricate(:user, email: 'alice@example.com') }

    before { ActionMailer::Base.deliveries.clear }

    it 'redirects to password reset confirmation path' do
      post :create, email: 'alice@example.com'
      expect(response).to redirect_to confirm_forgot_password_path
    end

    it 'sets a token for the user with this email' do
      expect(alice.token).to be_nil
      post :create, email: 'alice@example.com'
      expect(alice.reload.token).not_to be_nil
    end

    it 'sends out an email to the user with this email' do
      post :create, email: 'alice@example.com'
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end

    it 'sends out an email with the token' do
      post :create, email: 'alice@example.com'
      message = ActionMailer::Base.deliveries.last.body
      expect(message).to include(alice.reload.token)
    end

    it 'does not do anything if the user is not found' do
      post :create, email: 'someoneelse@example.com'
      expect(ActionMailer::Base.deliveries).to be_empty
      expect(alice.token).to be_nil
    end
  end

  describe 'GET confirm' do
    it 'renders the confirmation template' do
      get :confirm
      expect(response).to render_template('confirm')
    end
  end
end

