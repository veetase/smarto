class SpotComment < ActiveRecord::Base
  belongs_to :spot
  belongs_to :user

  validates :spot_id, :content, presence: true
  paginates_per 50
end
