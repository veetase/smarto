class Api::V2::SplashController < ApplicationController
	def current
		@splash = Splash.active.first
		respond_with @splash.as_json(:methods => [:picture_url])
	end
end
