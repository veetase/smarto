class Spot < ActiveRecord::Base
  belongs_to :user
  set_rgeo_factory_for_column(:location,
                                  RGeo::Geographic.spherical_factory(:srid => 4326))
  validates :perception_value, numericality: { greater_than: 0, less_than: 100}
  validates :comment, length: { maximum: 200 }
  validates :image, :image_shaped, length: { maximum: 100 }
  validates :avg_temperature, :mid_temperature, :max_temperature, :min_temperature, numericality: { greater_than: -100, less_than: 1000} # todo..  curracy the value
  validates :measure_duration, numericality: { greater_than: 0}
  validates :location, :image, :image_shaped, :mid_temperature, :avg_temperature, :max_temperature, :min_temperature, :user, :start_measure_time, :perception_value, :perception_tags, presence: true
  validate :validate_tags

  scope :near, lambda { |longitude, latitude, distance|
    where("ST_Distance(location,
                       "+"'POINT(#{longitude} #{latitude})') < #{distance}")}
  private
  def validate_tags
    if !perception_tags.is_a?(Array) || perception_tags.size > 10 || perception_tags.detect{|t| t.size > 10}
      errors.add(:perception_tags, :invalid)
    end
  end  
end