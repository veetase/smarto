class Voucher < ActiveRecord::Base
  has_many :users, through: :user_vouchers
  has_many :user_vouchers

  module Status
    FRESH    = 0
    USED     = 1
    DISABLED = 2
  end

  def generate_code(length=6)
    # uuid is too long.
    # use current time + random code is a better choise
    # time's length is 6 for now, total length = length + 6
    Time.now.to_i.to_s(36).upcase + [*('A'..'Z'),*('0'..'9')].shuffle[0,length].join
  end

  def use_one
    self.used_count = self.used_count.to_i + 1
  end
end
