class TemperTip < ActiveRecord::Base
  validates_presence_of :temper, :tip
end
