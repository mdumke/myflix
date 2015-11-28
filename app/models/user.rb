class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :reviews, -> { order('created_at desc') }
  has_many :queue_items, -> { order('queue_position') }

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  def queue_length
    queue_items.count
  end

  def has_queued?(video)
    queue_items.select { |qi| qi.video == video }.size > 0
  end

  def normalize_queue_item_positions!
    queue_items.each_with_index do |item, idx|
      item.update_attributes(queue_position: idx + 1)
    end
  end
end

