require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_a User
      expect(assigns(:user)).to be_a_new_record
    end
  end

  describe 'POST create' do
    context 'with valid input' do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end

      it 'creates a user' do
        expect(User.count).to eq 1
      end

      it 'redirects to videos path' do
        expect(response).to redirect_to videos_path 
      end
    end

    context 'with invalid input' do
      before do
        post :create, user: {full_name: '', password: '123'} 
      end

      it 'does not create a new user' do
        expect(User.count).to eq 0
      end

      it 'renders the new view' do
        expect(response).to render_template :new 
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_a User
      end
    end
  end
end
