require 'spec_helper'

describe VideosController do
  describe 'GET show/1' do
    let(:video) { Fabricate(:video) }

    it 'sets the @video variable for id 1' do
      get :show, id: video.id

      expect(assigns(:video)).to eq video
    end

    it 'renders the show view' do
      user = Fabricate(:user)
      session[:user_id] = user.id

      get :show, id: video.id

      expect(response).to render_template :show
    end
  end
end

