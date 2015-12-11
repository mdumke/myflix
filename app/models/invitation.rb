class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'

  validates :inviter, :recipient_name, :recipient_email, :message,
            presence: true
end

