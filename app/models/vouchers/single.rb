class Vouchers::Single < Voucher
  def self.fetch_by_name(name)
    voucher = Vouchers::Single.where(name: name, status: Voucher::Status::FRESH).first
    return voucher if voucher.available?
  end

  def available?
    (self.used_count.to_i <= self.max.to_i) && (self.expire_at < Time.now)
  end

  def generate_by_count(count)
    self.max = self.max.to_i + count.to_i
    self.code = self.generate_code
    self.save
  end
end
