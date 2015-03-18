class Subscriber
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :email, presence: true, uniqueness: true
	validates :email, presence: true
end
