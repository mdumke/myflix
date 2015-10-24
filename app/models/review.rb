class Review < ActiveRecord::Base
  belongs_to :user 
  belongs_to :video

  validates :rating,
    presence: true,
    numericality: {less_than: 6, greater_than: 0}

  validates :text, presence: true
end

