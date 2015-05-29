module ActiveSupport
  class TimeWithZone
    def as_json(options = nil)
      %(#{time.strftime("%Y-%m-%d %H:%M:%S")} #{formatted_offset(false)})
    end
  end
end
