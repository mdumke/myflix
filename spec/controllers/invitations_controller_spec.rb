require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    before { set_current_user }

    it 'sets @invitation' do
      get :new
      expect(assigns(:invitation)).to be_present
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    before do
      set_current_user
      clear_mail_queue
    end

    context 'with valid data' do
      before do
        post :create, invitation: {recipient_name: 'Al Schnell',
             recipient_email: 'valid@email.de',
             message: 'Please join!'}
      end

      it 'redirects to the home-path' do
        expect(response).to redirect_to home_path
      end

      it 'sets the flash-notice' do
        expect(flash[:notice]).to be_present
      end

      it 'creates a new invitation' do
        expect(Invitation.count).to eq(1)
      end

      it 'sends out an invitation to the specified email' do
        expect(ActionMailer::Base.deliveries).to be_present
      end
    end

    context 'with invalid data' do
      before do
        post :create, invitation: {recipient_name: 'Al Schnell'}
      end

      it 'renders the new view again' do
        expect(response).to render_template 'new'
      end

      it 'does not create a new invitation' do
        expect(Invitation.count).to eq(0)
      end

      it 'sets @invitation' do
        expect(assigns(:invitation)).to be_present
      end

      it 'sets the flash-error' do
        expect(flash[:error]).to be_present
      end
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { post :create }
    end
  end
end

