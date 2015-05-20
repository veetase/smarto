module Api
	class NotFound < StandardError
  end

	class Unauthorized < StandardError
	end

	class ParameterInvalid < StandardError
	end
end
