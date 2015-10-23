require 'spec_helper'

describe SessionsController do
  describe 'GET front' do
    it 'should render the front template for unauthenticated users' do
      get :front
      expect(response).to render_template :front
    end

    it 'should redirect to the home-path for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :front
      expect(response).to redirect_to home_path
    end
  end

  describe 'GET new' do
    it 'should render the new template for unauthenticated users' do
      get :new
      expect(response).to render_template :new
    end

    it 'should redirect to the home-path for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe 'POST create' do
    let (:user) { Fabricate(:user) }

    it 'logs in user with valid email and password' do
      post :create, email: user.email, password: user.password
      expect(session[:user_id]).to eq user.id
    end

    it 'redirects to videos-path for a user with valid email and password' do
      post :create, email: user.email, password: user.password
      expect(response).to redirect_to videos_path 
    end

    it 'does not log in user with invalid email' do
      post :create, email: 'another@email', password: user.password
      expect(session[:user_id]).to be_nil 
    end

    it 'does not log in user with invalid password' do
      post :create, email: user.email, password: 'false'
      expect(session[:user_id]).to be_nil 
    end

    it 'renders the new view if email or password are invalid' do
      post :create, email: user.email, password: 'false'
      expect(response).to render_template :new 
    end
  end

  describe 'GET destroy' do
    it 'logs out signed in user' do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be_nil
    end
  end
end

