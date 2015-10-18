class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  before_action :require_user

  def show
  end

  private

  def set_category
    @category = Category.find_by_id(params[:id])

    unless @category
      flash['error'] = 'Category not found'
      redirect_to root_path
    end
  end
end
