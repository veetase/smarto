class TemperTip < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :temper, :tip

  def tags=(values)
    self.tags.concat(values.gsub(/\s+/m, ' ').strip.split(" ")) if values
  end
end
