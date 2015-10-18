class VideosController < ApplicationController
  before_action :set_video, only: [:show]
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
  end

  def search
    @query = params[:q]
    @videos = Video.search_by_title(@query)
  end

  private

  def set_video
    @video = Video.find_by_id(params[:id])

    unless @video
      flash['error'] = 'Video not found'
      redirect_to root_path
    end 
  end
end
