class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video 

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review = Review.where(user: user, video: video).first
    review.rating if review
  end
end

