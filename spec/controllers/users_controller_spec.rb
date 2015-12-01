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
        recipient = ActionMailer::Base.deliveries.try(:first).try(:to)
        expect(recipient).not_to eq(['test@abc.com'])
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

  describe 'POST send_password_reset_link' do
    let!(:alice) { Fabricate(:user, email: 'alice@example.com') }

    before { ActionMailer::Base.deliveries.clear }

    it 'redirects to password reset confirmation path' do
      post :send_password_reset_link, email: 'alice@example.com'
      expect(response).to redirect_to confirm_password_reset_path
    end

    it 'sets a token for the user with this email' do
      expect(alice.token).to be_nil
      post :send_password_reset_link, email: 'alice@example.com'
      expect(alice.reload.token).not_to be_nil
    end

    it 'sends out an email to the user with this email' do
      post :send_password_reset_link, email: 'alice@example.com'
      expect(ActionMailer::Base.deliveries).not_to be_empty
    end

    it 'sends out an email with the token' do
      post :send_password_reset_link, email: 'alice@example.com'
      message = ActionMailer::Base.deliveries.last.body
      expect(message).to include(alice.reload.token)
    end

    it 'does not do anything if the user is not found' do
      post :send_password_reset_link, email: 'someoneelse@example.com'
      expect(ActionMailer::Base.deliveries).to be_empty
      expect(alice.token).to be_nil
    end
  end

  describe 'GET reset_password_form' do
    let!(:alice) { Fabricate(:user) }

    it 'redirects to the invlalid token path if the token is not found' do
      get :reset_password_form, id: 'abc'
      expect(response).to redirect_to invalid_token_path
    end

    it 'renders the reset-password-view when the token exists' do
      alice.update_attribute(:token, 'abc')
      get :reset_password_form, id: 'abc'
      expect(response).to render_template 'reset_password_form'
    end
  end

  describe 'POST reset_password' do
    let!(:alice) { Fabricate(:user, token: 'abc', password: 'xyz') }

    it 'redirects to the sign in path' do
      post :reset_password, token: 'abc', password: '123'
      expect(response).to redirect_to login_path
    end

    it 'sets the given password for the correct user' do
      post :reset_password, token: 'abc', password: '123'
      expect(alice.reload.authenticate('123')).to be_truthy
    end

    it 'deletes the token for the user' do
      post :reset_password, token: 'abc', password: '123'
      expect(alice.reload.token).to be_nil
    end

    it 'does not do anything when data is invlalid' do
      post :reset_password, token: 'def', password: '123'
      expect(alice.reload.authenticate('123')).to be_falsy
    end
  end
end

