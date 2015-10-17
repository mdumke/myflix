class VideosController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @video = Video.find_by_id(params[:id])
  end
end
