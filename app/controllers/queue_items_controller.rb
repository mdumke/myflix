class QueueItemsController < ApplicationController
  before_action :require_user
  before_action :set_video, only: [:create]

  def index
    @queue_items = current_user.queue_items
  end

  def create
    unless current_user.has_queued? @video
      QueueItem.create(
        queue_position: current_user.queue_length + 1,
        video: @video,
        user: current_user)
    end

    redirect_to my_queue_path
  end

  private

  def set_video
    @video = Video.find_by_id(params[:video_id])

    unless @video
      flash['error'] = 'Could not find this video'
      redirect_to videos_path
    end
  end
end

