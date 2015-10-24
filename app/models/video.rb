class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(query = '')
    return [] if query.blank?

    where('lower(title) like ?', "%#{ query.downcase }%")
      .order('created_at desc')
  end
end
