class Project < ApplicationRecord
  has_one_attached :image

  validates :title, presence: true
  validates :project_link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
  validates :repo_link, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true

  scope :ordered, -> { order(:position) }

  def to_s
    title
  end
end
