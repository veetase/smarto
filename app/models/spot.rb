class Spot
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :user

  field :location, type: Array
  field :perception, type: Hash
  field :picture, type: Hash
  field :env_info, type: Hash

  validates :location, :picture, :env_info, :user, presence: true

  index({ location: "2d" }, { min: -200, max: 200, background: true})
end
