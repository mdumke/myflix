require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    context 'with authenticated user' do
      let (:current_user) { Fabricate(:user) }
      let (:queue_item_1) { Fabricate(:queue_item) }

      before do
        queue_item_1.update_attributes(user: current_user)
        session[:user_id] = current_user.id
      end

      it "assigns a user's queue-items to @queue_items" do
        get :index
        expect(assigns(:queue_items)).to eq current_user.queue_items
      end
    end

    context 'with unauthenticated user' do
      it 'redirects to the root-path' do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'POST create' do
    context 'for authenticated user' do
      let (:current_user) { Fabricate(:user) }
      let (:video) { Fabricate(:video) }

      before { session[:user_id] = current_user.id }

      it 'redirects to the queue-path after successful adding' do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_path
      end

      it 'redirects to the videos path when video id is not valid' do
        post :create, video_id: (video.id + 1000)
        expect(response).to redirect_to videos_path
      end

      it 'sets the flash-error when video id is not valid' do
        post :create, video_id: (video.id + 1000)
        expect(flash['error']).not_to be_blank
      end

      it 'creates a new queue item' do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq 1
      end

      it 'creates the queue item for the passed in video' do
        post :create, video_id: video.id
        expect(video.queue_items.count).to eq 1
      end

      it 'creates the queue item for the current user' do
        post :create, video_id: video.id
        expect(current_user.queue_items.count).to eq 1
      end

      it 'sets the queue-position correctly' do
        post :create, video_id: video.id
        expect(QueueItem.first.queue_position).to eq 1
      end

      it 'does not add a video that is already in the queue' do
        Fabricate(:queue_item, user: current_user, video: video)

        post :create, video_id: video.id
        expect(QueueItem.count).to eq 1
      end
    end

    context 'for unauthenticated user' do
      it 'redirects to root-path' do
        post :create, video_id: 2
        expect(response).to redirect_to root_path
      end
    end
  end
end

