class UserVoucher < ActiveRecord::Base
  belongs_to :user
  belongs_to :voucher
  validates_uniqueness_of :voucher_id, scope: :user_id
end
