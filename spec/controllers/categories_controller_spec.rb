require 'spec_helper'

describe CategoriesController do
  describe 'GET show' do
    it 'sets the @category variable for authenticated users' do
      session[:user_id] = Fabricate(:user).id
      category = Fabricate(:category)

      get :show, id: category.id
      expect(assigns(:category)).to eq category
    end

    it 'redirects to root path for unauthenticated users' do
      get :show, id: Fabricate(:category).id
      expect(response).to redirect_to root_path
    end
  end
end

