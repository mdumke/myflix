require 'spec_helper'

describe CategoriesController do
  describe 'GET show' do
    it 'sets the @category variable for authenticated users' do
      set_current_user
      category = Fabricate(:category)

      get :show, id: category.id
      expect(assigns(:category)).to eq category
    end

    it_behaves_like 'requires authenticated user' do
      let(:action) { get :show, id: Fabricate(:category).id }
    end
  end
end

