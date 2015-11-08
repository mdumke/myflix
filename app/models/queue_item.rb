class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :queue_position, numericality: { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review.rating if review
  end

  def update_rating(new_rating)
    rev = review || Review.create(user: user, video: video)
    rev.rating = new_rating

    if rev.valid? || !rev.errors.keys.include?(:rating)
      rev.update_attribute(:rating, new_rating)
      return true
    end

    raise(ActiveRecord::RecordInvalid)
  end

  def review
    @review ||= Review.where(user: user, video: video).first
  end
end

