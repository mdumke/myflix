class VideosController < ApplicationController
  before_action :set_video, only: [:show, :review]
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @review = Review.new
    @reviews = @video.reviews
  end

  def search
    @query = params[:q]
    @videos = Video.search_by_title(@query)
  end

  def review
    review = Review.new(
      review_params.merge(video: @video, user: current_user))
    
    if review.save
      flash['notice'] = 'Thank you for reviewing this title.'
    else 
      flash['error'] = 'There was an error with your review.'
    end

    redirect_to video_path(@video)
  end

  private

  def set_video
    @video = Video.find_by_id(params[:id])

    unless @video
      flash['error'] = 'Video not found'
      redirect_to root_path
    end 
  end

  def review_params
    params.require(:review).permit(:rating, :text)
  end
end
