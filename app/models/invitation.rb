class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :inviter, :recipient, :message, presence: true
end

