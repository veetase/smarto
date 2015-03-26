class Spot
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user

  field :location
  field :perception_value, type: Integer
  field :perception_tags, type: Array
  field :comment, type: String
  field :avg_temperature, type: Float
  field :mid_temperature, type: Float
  field :max_temperature, type: Float
  field :min_temperature, type: Float
  field :start_measure_time, type: Time
  field :measure_duration, type: Integer
  field :image, type: String
  field :image_shaped, type: String
  field :is_public, type: Boolean, default: true

  validates :location, :image, :image_shaped, :mid_temperature, :avg_temperature, :max_temperature, :min_temperature, :user, :start_measure_time, :perception_value, :perception_tags, presence: true
  index({ location: "2dsphere" })

  validates :perception_value, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :perception_tags, array: { presence: true, length: {maximum: 16}}
  validates :mid_temperature, :avg_temperature, :max_temperature, :min_temperature, numericality: {greater_than_or_equal_to: -100, less_than_or_equal_to: 500}
  validates_numericality_of :measure_duration, greater_than: 0
  validate :validate_location_format

  private
  def validate_location_format
    self.errors.add(:location, 'location invalid format') unless self.location.keys == ["type", "coordinates"]
    self.errors.add(:location, 'location type invalid') unless ["Point", "MultiPoint", "Polygon"].include?(location[:type])
    location[:coordinates].each do |c|
      self.errors.add(:location, 'location value invalid') if (c < -180 || c > 180)
    end
  end
end