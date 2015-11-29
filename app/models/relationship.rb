class Relationship < ActiveRecord::Base
  belongs_to :leader, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  validates :leader, presence: true
  validates :follower, presence: true
end

