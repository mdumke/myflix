require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    it 'sets the @user variable' do
      get :new
      expect(assigns(:user)).to be_a_new_record
    end
  end

  describe 'POST create' do
    let (:full_name) { Faker::Name.name }
    let (:password)  { Faker::Internet.password(8) }
    let (:email)     { Faker::Internet.email }

    it 'creates a user when data is valid' do
      post :create, user: {full_name: full_name, password: password, email: email}

      expect(User.first.full_name).to eq full_name
      expect(User.first.email).to eq email
    end

    it 'redirects to videos path when data is valid' do
      post :create, user: {full_name: full_name, password: password, email: email}

      expect(response).to redirect_to videos_path 
    end

    it 'does not create a new user when data is invalid' do
      post :create, user: {full_name: '', password: '123'}
      expect(User.all.size).to eq 0
    end

    it 'renders the new view when data is invalid' do
      post :create, user: {full_name: '', password: '123'}
      expect(response).to render_template :new 
    end
  end
end

