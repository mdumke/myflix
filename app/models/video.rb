class Video < ActiveRecord::Base
  belongs_to :category

  has_many :reviews, -> { order('created_at desc') }
  has_many :queue_items

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(query = '')
    return [] if query.blank?

    where('lower(title) like ?', "%#{ query.downcase }%")
      .order('created_at desc')
  end

  # returns the rating-average from all reviews
  def avg_rating
    ratings = reviews.map(&:rating).compact
    (ratings.sum.to_f / ratings.count).round(1)
  end
end
