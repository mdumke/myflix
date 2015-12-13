require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    let!(:alice) { Fabricate(:user) }

    it 'redirects to the invlalid token path if the token is not found' do
      get :show, id: 'abc'
      expect(response).to redirect_to invalid_token_path
    end

    it 'renders the reset-password-view when the token exists' do
      alice.update_attribute(:token, 'abc')
      get :show, id: 'abc'
      expect(response).to render_template 'show'
    end
  end

  describe 'PATCH update' do
    let!(:alice) { Fabricate(:user, token: 'abc', password: 'xyz') }

    it 'redirects to the sign in path' do
      patch :update, id: 'abc', password: '123'
      expect(response).to redirect_to login_path
    end

    it 'sets the given password for the correct user' do
      patch :update, id: 'abc', password: '123'
      expect(alice.reload.authenticate('123')).to be_truthy
    end

    it 'deletes the token for the user' do
      patch :update, id: 'abc', password: '123'
      expect(alice.reload.token).to be_nil
    end

    it 'does not do anything when data is invalid' do
      patch :update, id: 'def', password: '123'
      expect(alice.reload.authenticate('123')).to be_falsy
    end
  end
end

