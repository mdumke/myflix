require 'spec_helper'

describe VideosController do
  describe 'GET index' do
    it 'sets the @categories variable for authenticated users' do
      set_current_user
      get :index
      expect(assigns(:categories)).to_not be_nil
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :index }
    end
  end

  describe 'GET show' do
    let(:video) { Fabricate(:video) }

    context 'for authenticated users' do
      before do
        set_current_user
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

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :show, id: video.id }
    end
  end

  describe 'GET search' do
    let(:dogtooth)  { Fabricate(:video, title: 'dogtooth') }
    let(:godfather) { Fabricate(:video, title: 'godfather') }

    it 'sets @videos for authenticated users' do
      set_current_user
      get :search, q: 'tooth'
      expect(assigns(:videos)).to eq([dogtooth])
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :search, q: 'tooth' }
    end
  end

  describe 'POST review' do
    let (:modern_times) { Fabricate(:video, title: 'Modern Times') }

    before { set_current_user }

    context 'with valid review-data' do
      before do
        post :review, id: modern_times.id, review: {rating: 4, text: 'abc'}
      end

      it 'creates the review for the given video' do
        expect(Review.first.video).to eq modern_times
      end

      it 'creates the review for the current user' do
        expect(Review.first.user).to eq current_user
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

