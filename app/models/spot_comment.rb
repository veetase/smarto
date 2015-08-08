class SpotComment < ActiveRecord::Base
  belongs_to :spot
  belongs_to :user

  validates :spot_id, :content, presence: true
  paginates_per 50

  def self.count_by_post_date(start_date, end_date)
    where('created_at >= ? and created_at <= ?', start_date, end_date).group('date(created_at)').order('date(created_at)').count
  end
end
