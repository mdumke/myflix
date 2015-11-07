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
    begin
      if valid_queue_item_data?
        update_queue_positions
        fix_item_counts
        flash['notice'] = 'Successfully updated My Queue'
      end
    rescue ActiveRecord::RecordInvalid
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

  def update_queue_positions
    return unless valid_queue_item_data?

    ActiveRecord::Base.transaction do
      params[:queue].each do |item_data|
        item = QueueItem.find_by_id(item_data[:id])

        unless item.update_attributes!(queue_position: item_data[:position])
          fail(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  def valid_queue_item_data?
    params[:queue].all? { |item_data| item_data[:id] }
  end

  def fix_item_counts
    current_user
      .queue_items
      .each_with_index do |item, idx|
        item.update_attributes(queue_position: idx + 1)
      end
  end
end

