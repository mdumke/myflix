require 'spec_helper'

describe SessionsController do
  describe 'GET front' do
    it 'redirects to the home-path for authenticated users' do
      set_current_user
      get :front
      expect(response).to redirect_to home_path
    end

    it 'renders the front template for unauthenticated users' do
      get :front
      expect(response).to render_template :front
    end
  end

  describe 'GET new' do
    it 'redirects to the home-path for authenticated users' do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it 'renders the new template for unauthenticated users' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    let (:alice) { Fabricate(:user, token: 'abc') }

    context 'with valid credentials' do
      before do
        post :create, email: alice.email, password: alice.password
      end

      it 'puts the user in the session' do
        expect(session[:user_id]).to eq alice.id
      end

      it 'redirects to the videos-path' do
        expect(response).to redirect_to videos_path
      end

      it 'sets the notice' do
        expect(flash['notice']).not_to be_blank
      end

      it 'deletes a users token if there still is one' do
        expect(alice.reload.token).to be_nil
      end
    end

    context 'with invalid credentials' do
      before do
        post :create, email: alice.email, password: alice.password + 'asdf'
      end

      it 'does not put the user in the session' do
        expect(session[:user_id]).to be_nil
      end

      it 'renders the new view if email or password are invalid' do
        expect(response).to render_template :new
      end

      it 'sets the error-message' do
        expect(flash['error']).not_to be_blank
      end
    end
  end

  describe 'GET destroy' do
    before do
      set_current_user
      get :destroy
    end

    it 'logs out signed in user' do
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the root-path' do
      expect(response).to redirect_to root_path
    end

    it 'sets the notice' do
      expect(flash['notice']).not_to be_blank
    end
  end
end

