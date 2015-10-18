class VideosController < ApplicationController
  before_action :set_video, only: [:show]

  def index
    @categories = Category.all
  end

  def show
  end

  def search
    @videos = Video.search_by_title(params[:q])
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
