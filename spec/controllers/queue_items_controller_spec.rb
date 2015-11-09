require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    let (:queue_item_1) { Fabricate(:queue_item) }

    before do
      set_current_user
      queue_item_1.update_attributes(user: current_user)
    end

    it "assigns a user's queue-items to @queue_items" do
      get :index
      expect(assigns(:queue_items)).to eq current_user.queue_items
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    let (:video) { Fabricate(:video) }

    before { set_current_user }

    it 'redirects to the queue-path after successful creation' do
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

    it_behaves_like 'requires authenticated user' do
      let(:action) { post :create, video_id: 2 }
    end
  end

  describe 'PATCH update' do
    let(:video1) { Fabricate(:video) }
    let(:video2) { Fabricate(:video) }
    let(:item1) do
      Fabricate(:queue_item,
        queue_position: -1, user: current_user, video: video1)
    end

    let(:item2) do
      Fabricate(:queue_item,
        queue_position: -1, user: current_user, video: video2)
    end

    before do
      set_current_user
      item1.rating = 1
      item2.rating = 2
    end

    # updating queue positions
    it 'redirects to my_queue_path for invalid positions' do
      patch :update_queue, queue: [
        {id: item1.id, position: 1.5, rating: 1}]

      expect(response).to redirect_to my_queue_path
    end

    it 'sets the flash-error for invalid positions' do
      patch :update_queue, queue: [
        {id: item1.id, position: 1.5, rating: 1}
      ]

      expect(flash[:error]).to be_present
    end

    it 'reorders positions so that the lowest position is 1' do
      patch :update_queue, queue: [
        {id: item1.id, position: 3, rating: 1},
        {id: item2.id, position: 2, rating: 1}
      ]
      expect(QueueItem.find(item2.id).queue_position).to eq 1
    end

    it 'reorders so that all positions are contiguous' do
      patch :update_queue, queue: [
        {id: item1.id, position: 3, rating: 1},
        {id: item2.id, position: 2, rating: 1}
      ]
      expect(QueueItem.find(item1.id).queue_position).to eq 2
      expect(QueueItem.find(item2.id).queue_position).to eq 1
    end

    it 'updates all positions in a transaction' do
      patch :update_queue, queue: [
        {id: item1.id, position: 3, rating: 1},
        {id: item2.id, position: 2.5, rating: 1}
      ]
      expect(QueueItem.find(item1.id).queue_position).to eq -1
      expect(QueueItem.find(item2.id).queue_position).to eq -1
    end

    it 'redirects to my_queue after successful update' do
      patch :update_queue, queue: [
        {id: item1.id, position: 1, rating: 1},
        {id: item2.id, position: 2, rating: 1}
      ]
      expect(response).to redirect_to my_queue_path
    end

    it 'does not update queue when position-data is incomplete' do
      patch :update_queue, queue: [
        {id: item1.id, position: 1, rating: 1},
        {id: item2.id, rating: 1}
      ]
      expect(item1.reload.queue_position).to eq -1
    end

    it 'does not update queue when id-data is incomplete' do
      patch :update_queue, queue: [
        {id: item1.id, position: 1, rating: 1},
        {position: 2, rating: 1}
      ]
      expect(item1.reload.queue_position).to eq -1
    end

    it 'sets the error-flash for incomplete request-information' do
      patch :update_queue, queue: [
        {id: item1.id, position: 1, rating: 1},
        {id: item2.id, rating: 1}
      ]
      expect(flash['error']).to be_present
    end

    it 'does not update queue items that do not belong the current user' do
      item1.update_attributes(user_id: current_user.id + 1)
      patch :update_queue, queue: [{id: item1.id, position: 1, rating: 1}]
      expect(item1.reload.queue_position).to eq -1
    end

    # changing video ratings
    it 'updates a single video' do
      patch :update_queue, queue: [{id: item1.id, rating: 3, position: 1}]
      expect(item1.reload.rating).to eq 3
    end

    it 'updates a single video to nil for empty string' do
      patch :update_queue, queue: [{id: item1.id, rating: '', position: 1}]
      expect(item1.reload.rating).to be_nil
    end

    it 'does not update when data is invalid' do
      patch :update_queue, queue: [{id: item1.id, rating: 3}]
      expect(item1.reload.rating).to eq 1
    end

    it 'sets the flash-error when data is invalid' do
      patch :update_queue, queue: [{id: item1.id, rating: 3}]
      expect(flash['error']).to be_present
    end

    it 'only changes the videos that actually belong to the user' do
      session[:user_id] = current_user.id + 1
      patch :update_queue, queue: [{id: item1.id, rating: 3, position: 1}]
      expect(item1.reload.rating).to eq 1
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { patch :update_queue }
    end
  end

  describe 'DELETE destroy' do
    let (:item1) { Fabricate(:queue_item) }
    let (:item2) { Fabricate(:queue_item) }
    let (:item3) { Fabricate(:queue_item) }

    before { set_current_user }

    context 'queue items belong to the current user' do
      before do
        item1.update_attributes(queue_position: 2, user: current_user)
        item2.update_attributes(queue_position: 3, user: current_user)
        item3.update_attributes(queue_position: 1, user: current_user)

        delete :destroy, id: item1.id
      end

      it 'redirects to my-queue-path for aunhenticated users' do
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

    it 'queue items do not belong to the current user' do
      bob = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq 1
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { delete :destroy, id: item1.id }
    end
  end
end

