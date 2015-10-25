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

  describe 'DELETE destroy' do
    let (:alice) { Fabricate(:user) }
    let (:item1) { Fabricate(:queue_item) }
    let (:item2) { Fabricate(:queue_item) }
    let (:item3) { Fabricate(:queue_item) }

    context 'with authenticated user' do
      before do
        session[:user_id] = alice.id

        item1.update_attributes(queue_position: 2, user: alice)
        item2.update_attributes(queue_position: 3, user: alice)
        item3.update_attributes(queue_position: 1, user: alice)

        delete :destroy, id: item1.id
      end

      it 'redirects to my-queue-path for authenticated users' do
        expect(response).to redirect_to my_queue_path
      end

      it 'deletes a queue entry for authenticated users' do
        expect(QueueItem.count).to eq 2
      end

      it 'fixes the counters for the remaining queue items' do
        expect(item2.reload.queue_position).to eq 2
        expect(item3.reload.queue_position).to eq 1
      end
    end

    it 'does not delete the queue item if it is not in the current users queue' do
      alice = Fabricate(:user)
      bob   = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: bob)
      session[:user_id] = alice.id

      delete :destroy, id: queue_item.id

      expect(QueueItem.count).to eq 1
    end

    it 'redirects to root_path for unauthenticated users' do
      delete :destroy, id: item1.id
      expect(response).to redirect_to root_path
    end
  end
end

