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

  def destroy
    item = QueueItem.find(params[:id])
    item.destroy if item && current_user.queue_items.include?(item)

    fix_item_counts

    redirect_to my_queue_path
  end

  def update_queue
    params[:queue].each do |queue_item|
      item = QueueItem.find_by_id(queue_item[:id])
      next unless item

      item.update_attributes(queue_position: queue_item[:position])
    end

    fix_item_counts

    flash['error'] = 'Your changes could not be saved'
    render 'index'
  end

  private

  def set_video
    @video = Video.find_by_id(params[:video_id])

    unless @video
      flash['error'] = 'Could not find this video'
      redirect_to videos_path
    end
  end

  def fix_item_counts
    items = current_user.queue_items
    return if items.empty?

    items
      .sort_by(&:queue_position)
      .each_with_index do |item, idx|
        item.update_attributes(queue_position: idx + 1)
      end
  end
end

