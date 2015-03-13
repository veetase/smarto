require 'grab/weather_cn'
class Api::V1::SpotsController < ApplicationController
	before_action :authenticate_with_token, only: [:create, :destroy]
	def show
		respond_with spot = Spot.find(params[:id])
	end

	def create
		spot = current_user.spots.build(spot_params)

		if spot.save
      		render json: {result: "success"}, status: 201, location: [:api, spot]
    	else
      		render json: { errors: spot.errors }, status: 422
    	end
	end

	def destroy
	    spot = current_user.spots.find(params[:id])
	   	spot.destroy
	    head 204
	end

	def around
		# max_distance units is meters when location data stored as geoJSON
		coordinate = params.require(:coordinate).collect{|x| x.to_i}
		distance = params[:distance].to_f || 1.0

		spots = Spot.geo_near(coordinate).max_distance(distance / 6371).spherical
		weather = nil
		if area_id = params[:area_id]
			weather_cn = WeatherCn.new(area_id)
			weather = weather_cn.fetch_weather
		end

		render json: {spots: spots, weather_cn: weather}
	end

	private
	def spot_params
	  attr = params.require(:spot).permit!
	  attr["location"]["coordinates"] = attr["location"]["coordinates"].collect{|x| x.to_i} if attr["location"]
	  return attr
	end
end
