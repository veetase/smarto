class TelAttribution < ActiveRecord::Base
  belongs_to :user

  def self.count_by_city
    group('city').count
  end
end
