class Address < ActiveRecord::Base
  belongs_to :user
  validates :user_id, :name, :city, :district, :detail, presence: true
end
