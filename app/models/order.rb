class Order < ActiveRecord::Base
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, :status, presence: true
  validate :validate_quantity
  validate :validate_ship
  before_validation :set_total!
  after_create :set_order_no

  module PAY_METHODS
    ALIPAY = 0
    WX     = 1 #Wechat pay
    UPACP  = 2 #union pay
  end

  PENDING   = 1
  CANCELED  = 2
  PAYING    = 3
  COMPLETED = 4
  REFUNDING = 5
  REFUNDED  = 6


  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      id, quantity = product_id_and_quantity

      self.placements.build(product_id: id, quantity: quantity)
    end
  end

  def go_to_status(to_status)
    raise Api::ParameterInvalid if to_status >= self.status.to_i
    self.status = to_status
  end

  def create_charge(channel, client_ip, currency="cny")
    Pingpp::Charge.create(
      :order_no  => self.order_no,
      :app       => { :id => BxgConfig.pingpp.app_id },
      :channel   => channel,
      :amount    => self.total,
      :client_ip => client_ip,
      :currency  => currency,
      :subject   => Order.human_attribute_name("subject"),
      :body      => self.products.collect{|p| "#{x.title} x #{p.quantity}"}.join(", ")
    )
  rescue
    raise Api::ThirdPartyError
  end

  private
  def set_total!
    self.total = 0
    placements.each do |placement|
      self.total += placement.product.price * placement.quantity
    end
  end

  def validate_quantity
    self.placements.each do |placement|
      product = placement.product
      if placement.quantity > product.quantity
        record.errors["#{product.title}"] << "Is out of stock, just #{product.quantity} left"
      end
    end
  end

  def validate_ship

  end

  # union pay require order no length 8-20
  def set_order_no
    remain_length = 10 - self.id.to_s.length
    self.order_no = self.id
    self.order_no << [*"0".."9"].sample(remain_length).join if remain_length > 0
  end
end
