class GuideStep < ApplicationRecord
  belongs_to :guide
  has_one_attached :image

  validates :title, presence: true
end
