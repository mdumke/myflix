require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it 'sets @follower_relationships' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      set_current_user(alice)
      get :index
      expect(assigns(:follower_relationships)).to eq([relationship])
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    before do
      set_current_user(alice)
      request.env["HTTP_REFERER"] = "where_i_came_from"
    end

    it 'creates a new relationship with the current user as follower' do
      post :create, leader_id: bob
      expect(alice.reload.leaders).to eq([bob])
    end

    it 'sets the flash-notice when creation was successful' do
      post :create, leader_id: bob
      expect(flash[:notice]).to be_present
    end

    it 'sets the error flash when creation was not successful' do
      post :create, leader_id: bob.id + 20
      expect(flash[:error]).to be_present
    end

    it 'does not do anything if the user is already following' do
      Fabricate(:relationship, leader: bob, follower: alice)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end

    it 'does not allow a user to follow themselves' do
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { xhr :post, :create, user_id: 1 }
    end
  end

  describe 'DELETE destroy' do
    it 'deletes a relationship' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      set_current_user(alice)
      delete :destroy, id: relationship.id
      expect(alice.reload.follower_relationships).to be_empty
    end

    it 'redirects to the people-page' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: alice)
      set_current_user(alice)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end

    it 'only deletes a relationship that belongs to the current user' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      carol = Fabricate(:user)
      relationship = Fabricate(:relationship, leader: bob, follower: carol)
      set_current_user(alice)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { delete :destroy, id: 1 }
    end
  end
end

