require 'spec_helper'

describe InvitationsController do
  describe 'GET new' do
    before { set_current_user }

    it 'sets @inviter' do
      get :new
      expect(assigns(:inviter)).to eq(current_user)
    end

    it 'sets @invitation' do
      get :new
      expect(assigns(:invitation)).to be_present
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :new }
    end
  end
end

