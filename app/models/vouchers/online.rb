class Vouchers::Online < Voucher
  def self.fetch_by_name(name)
    Vouchers::Template.fetch_by_name(name)
  end
end
