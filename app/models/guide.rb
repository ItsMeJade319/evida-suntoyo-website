class Guide < ApplicationRecord
  has_one_attached :image
  has_many :steps, -> { order(:position) }, class_name: "GuideStep", dependent: :destroy

  accepts_nested_attributes_for :steps, allow_destroy: true,
    reject_if: proc { |attrs| attrs["title"].blank? && attrs["content"].blank? }

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  before_save :set_published_at, if: -> { published? && published_at.blank? }
  before_save :assign_step_positions

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true,
    format: { with: /\A[a-z0-9]+(-[a-z0-9]+)*\z/, message: "must be lowercase letters, numbers, and hyphens only" }

  scope :published, -> { where(published: true).where(published_at: ..Time.current).order(published_at: :desc) }

  def to_param
    slug
  end

  def to_s
    title
  end

  private

  def generate_slug
    self.slug = title.parameterize
  end

  def set_published_at
    self.published_at = Time.current
  end

  def assign_step_positions
    steps.each_with_index { |step, index| step.position = index }
  end
end
