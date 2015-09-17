class Spot < ActiveRecord::Base
  belongs_to :user
  include SpotConcern
  has_many :spot_comments, after_add: :add_count
  module Category
    INDOOR  = 0
    OUTDOOR = 1
    BODY    = 2
  end

  module Status
    PUBLISHED = 0
    REJECT = 1
  end

  validates :perception_value, numericality: { greater_than_or_equal_to: -50, less_than_or_equal_to: 50}
  validates :comment, length: { maximum: 200 }
  validates :image, :image_shaped, length: { maximum: 100 }
  validates :avg_temperature, :mid_temperature, :max_temperature, :min_temperature, numericality: { greater_than_or_equal_to: -40, less_than_or_equal_to: 125} # todo..  curracy the value
  validates :measure_duration, numericality: { greater_than: 0}
  validates :location, :image, :image_shaped, :mid_temperature, :avg_temperature, :max_temperature, :min_temperature, :start_measure_time, :perception_value, :perception_tags, presence: true
  validate :validate_tags
  validates :category, numericality: { greater_than: 0, less_than: 10}

  scope :published, lambda {where(status: Status::PUBLISHED)}

  def reject
    self.status = Status::REJECT
    self.save
  end

  def activate
    self.status = Status::PUBLISHED
    self.save
  end

  def self.count_by_post_date(start_date, end_date)
    where('created_at >= ? and created_at <= ?', start_date, end_date).group('date(created_at)').order('date(created_at)').count
  end

  def json_show
    self.as_json(include: { user: { only: [:id, :avatar, :gender, :nick_name]} }, except: [:is_public, :user_id])
  end

  private
  def validate_tags
    if !perception_tags.is_a?(Array) || perception_tags.size > 10 || perception_tags.detect{|t| t.size > 10}
      errors.add(:perception_tags, :invalid)
    end
  end
end
