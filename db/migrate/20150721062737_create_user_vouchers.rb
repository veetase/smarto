class CreateUserVouchers < ActiveRecord::Migration
  def change
    create_table :user_vouchers, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :voucher, index: true
      t.timestamp
    end
  end
end
