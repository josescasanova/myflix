class Video < ActiveRecord::Base
  has_many :video_categories
  has_many :categories, through: :video_categories
#  has_many :reviews, order: "created_at DESC"
  has_many :reviews, -> { order("created_at DESC") }

  validates :title, presence: true
  validates :description, presence: true

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end
end