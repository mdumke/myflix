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
end

