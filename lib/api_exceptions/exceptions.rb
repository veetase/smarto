module Api
	class NotFound < StandardError
  end

	class Unauthorized < StandardError
	end

	class ParameterInvalid < StandardError
	end

	class ThirdPartyError < StandardError
	end
end
