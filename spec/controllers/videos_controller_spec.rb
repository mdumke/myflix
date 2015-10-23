require 'spec_helper'

describe VideosController do
  describe 'GET index' do
    it 'sets the @categories variable for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :index
      expect(assigns(:categories)).to_not be_nil
    end

    it 'redirects to front page for unauthenticated users' do
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    it 'sets @video for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'redirects unauthenticated users to sign in page' do
      get :show, id: video.id
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET search' do
    let(:dogtooth)  { Fabricate(:video, title: 'dogtooth') }
    let(:godfather) { Fabricate(:video, title: 'godfather') }

    it 'sets @videos for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :search, q: 'tooth'
      expect(assigns(:videos)).to eq([dogtooth])
    end

    it 'redirects unauthenticated users to sign in page' do
      get :search, q: 'tooth'
      expect(response).to redirect_to root_path
    end
  end
end

