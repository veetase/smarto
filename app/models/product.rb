class Product < ActiveRecord::Base
  has_many :placements
  has_many :orders, through: :placements
  validates :title, :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 },
                  presence: true
end
