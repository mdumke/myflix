class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :reviews
  has_many :queue_items

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
end

