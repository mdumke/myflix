class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :full_name, presence: true
  validates :email, presence: true
  validates :password, presence: true, confirmation: true
end

