require 'spec_helper'

describe UsersController do
  describe 'GET show' do
    before { set_current_user }

    it 'sets @user' do
      get :show, id: current_user.id
      expect(assigns(:user)).to eq(current_user)
    end

    it 'redirects to home path if a user is not found' do
      get :show, id: current_user.id + 10
      expect(response).to redirect_to home_path
    end

    it 'sets a flash error if a user is not found' do
      get :show, id: current_user.id + 10
      expect(flash[:error]).to be_present
    end

    it 'sets @videos' do
      anne = Fabricate(:user)
      video = Fabricate(:video)
      qi = Fabricate(:queue_item, video: video, user: anne)
      get :show, id: anne.id
      expect(assigns(:videos)).to eq([video])
    end

    it 'sets @reviews' do
      anne = Fabricate(:user)
      review = Fabricate(:review, user: anne)
      get :show, id: anne.id
      expect(assigns(:reviews)).to eq([review])
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :show, id: 1 }
    end
  end

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

    context 'email sending' do
      after { ActionMailer::Base.deliveries.clear }

      it 'sends out an email' do
        post :create, user: Fabricate.attributes_for(:user)
        expect(ActionMailer::Base.deliveries).to be_present
      end

      it 'sends to the correct recipient' do
        post :create, user: Fabricate.attributes_for(:user)
        recipient = ActionMailer::Base.deliveries.last.to
        expect(recipient).to eq([current_user.email])
      end

      it 'sends the correct content' do
        post :create, user: Fabricate.attributes_for(:user)
        content = ActionMailer::Base.deliveries.last.body
        expect(content).to include("Welcome #{current_user.full_name}")
      end

      it 'does not deliver an email for invalid data' do
        post :create, user: {email: 'test@abc.com'}
        expect(ActionMailer::Base.deliveries).to be_empty
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

