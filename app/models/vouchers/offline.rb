class Vouchers::Offline < Voucher
  def self.fetch_by_name(name)
    Vouchers::Offline.where(name: name, status: Voucher::Status::FRESH).first
  end

  def generate_by_count(count)
    vouchers = []
    count.to_i.times do
      self.code = self.generate_code
      vouchers << self.attributes
    end
    Vouchers::Offline.create(vouchers)
  end
end
