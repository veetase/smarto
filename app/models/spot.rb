class Spot < ActiveRecord::Base
  belongs_to :user
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

  set_rgeo_factory_for_column(:location,
                                  RGeo::Geographic.spherical_factory(:srid => 4326))
  validates :perception_value, numericality: { greater_than_or_equal_to: -50, less_than_or_equal_to: 50}
  validates :comment, length: { maximum: 200 }
  validates :image, :image_shaped, length: { maximum: 100 }
  validates :avg_temperature, :mid_temperature, :max_temperature, :min_temperature, numericality: { greater_than_or_equal_to: -40, less_than_or_equal_to: 125} # todo..  curracy the value
  validates :measure_duration, numericality: { greater_than: 0}
  validates :location, :image, :image_shaped, :mid_temperature, :avg_temperature, :max_temperature, :min_temperature, :start_measure_time, :perception_value, :perception_tags, presence: true
  validate :validate_tags
  validates :category, numericality: { greater_than: 0, less_than: 10}

  scope :near, lambda { |longitude, latitude, distance|
    where("ST_Distance(location,
                       "+"'POINT(#{longitude} #{latitude})') < #{distance}")}
  scope :published, lambda {where(status: Status::PUBLISHED)}

  def reject
    self.status = Status::REJECT
    self.save
  end

  def activate
    self.status = Status::PUBLISHED
    self.save
  end

  def add_view_count
    cache_name = view_count_cache
    count = $redis.get(cache_name).to_i
    if count > 10
      self.view_count += count
      self.save
      $redis.set(cache_name, 1) #added one
    else
      $redis.set(cache_name, count + 1)
    end
  end

  def self.count_by_post_date(start_date, end_date)
    where('created_at >= ? and created_at <= ?', start_date, end_date).group('date(created_at)').order('date(created_at)').count
  end

  def as_json(options={})
    result = super
    result["view_count"] = result["view_count"].to_i + $redis.get(view_count_cache).to_i
    result
  end

  private
  def validate_tags
    if !perception_tags.is_a?(Array) || perception_tags.size > 10 || perception_tags.detect{|t| t.size > 10}
      errors.add(:perception_tags, :invalid)
    end
  end

  def add_count(coment)
    self.comment_count = self.comment_count + 1

    cache_name = view_count_cache
    cached_view_count = $redis.get(cache_name).to_i

    self.view_count += cached_view_count
    self.save
    $redis.set(cache_name, 0)
  end

  def view_count_cache
    "spot_#{self.id}"
  end
end
