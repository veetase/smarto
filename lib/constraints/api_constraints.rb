class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    if req.headers['Accept'].include?("application/vnd.smarto.v")
      req.headers['Accept'].include?("application/vnd.smarto.v#{@version}")
    elsif @default
      true
    else
      false
    end
  end
end
