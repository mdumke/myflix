require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it 'sets @people' do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      bob.followers.push(alice)
      set_current_user(alice)
      get :index
      expect(assigns(:people)).to eq([bob])
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :index }
    end
  end
end

