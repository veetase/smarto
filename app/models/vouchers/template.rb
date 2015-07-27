# template to auto generate online vouchers
class Vouchers::Template < Voucher
  def self.fetch_by_name(name)
    temp = Vouchers::Template.where(name: name, status: Voucher::Status::FRESH).first
    if temp.available?
      code = self.generate_code(10)
      online_voucher = Vouchers::Online.new(temp.attributes)
      online_voucher.code = code
      online_voucher.save

      online_voucher
    end
  end

  def generate_by_count(count)
    self.max = self.max.to_i + count.to_i
    self.save
  end

  def available?
    (self.used_count.to_i <= self.max.to_i) && (self.expire_at < Time.now)
  end
end
