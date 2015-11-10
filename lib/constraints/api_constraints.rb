class ApiConstraints
  def initialize(options)
    @version = options[:version]
  end

  def matches?(req)
    request_version = req.headers['Accept'].split("application/vnd.smarto.v").last.to_i
    request_version >= @version
  end
end
