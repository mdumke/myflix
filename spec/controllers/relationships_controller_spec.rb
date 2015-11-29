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

