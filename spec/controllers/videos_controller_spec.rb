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

    context 'for authenticated users' do
      before do
        session[:user_id] = Fabricate(:user).id
        get :show, id: video.id
      end

      it 'sets @video' do
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @review' do
        expect(assigns(:review)).not_to be_nil
      end

      it 'sets @reviews' do
        expect(assigns(:reviews)).not_to be_nil
      end
    end

    context 'for unauthenticated users' do
      it 'redirects to the sign in page' do
        get :show, id: video.id
        expect(response).to redirect_to root_path
      end
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

  describe 'POST review' do
    let (:alice) { Fabricate(:user) }
    let (:modern_times) { Fabricate(:video, title: 'Modern Times') }

    before { session[:user_id] = alice.id }

    context 'with valid review-data' do
      before do
        post :review, id: modern_times.id, review: {rating: 4, text: 'abc'}
      end

      it 'creates the review for the given video' do
        expect(Review.first.video).to eq modern_times
      end

      it 'creates the review for the current user' do
        expect(Review.first.user).to eq alice
      end

      it 'redirects to the video show page' do
        expect(response).to redirect_to video_path(modern_times)
      end

      it 'sets the flash-notice' do
        expect(flash['notice']).not_to be_blank
      end
    end

    context 'with invalid review-data' do
      before do
        post :review, id: modern_times.id, review: {rating: 4}
      end

      it 'does not create a new review' do
        expect(Review.count).to eq 0
      end

      it 'redirects to the video show page' do
        expect(response).to redirect_to video_path(modern_times)
      end

      it 'sets the flash-error' do
        expect(flash['error']).not_to be_blank
      end
    end
  end
end

