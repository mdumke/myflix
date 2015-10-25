class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video 

  def video_title
    video.title
  end

  def category_name
    video.category.name
  end

  def category
    video.category
  end

  def rating
    review = Review.where(user: user, video: video).first
    review ? review.rating : nil
  end
end

