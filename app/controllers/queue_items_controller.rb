class QueueItemsController < ApplicationController
  InvalidQueueItemData = Class.new(StandardError)

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

    current_user.normalize_queue_item_positions!
    redirect_to my_queue_path
  end

  def update_queue
    begin
      fail(InvalidQueueItemData) unless valid_queue_item_data?
      update_queue_items
      current_user.normalize_queue_item_positions!
      flash['notice'] = 'Successfully updated My Queue'
    rescue ActiveRecord::RecordInvalid
      flash['error'] = 'Queue update failed'
    rescue InvalidQueueItemData
      flash['error'] = 'Queue update failed'
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

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue].each do |item_data|
        item = QueueItem.find_by_id(item_data[:id])
        next unless item.user == current_user

        item.update_attributes!(
          queue_position: item_data[:position],
          rating: item_data[:rating])
      end
    end
  end

  def valid_queue_item_data?
    params[:queue].all? do |item_data|
      item_data[:id] && item_data[:position] && item_data[:rating]
    end
  end
end
