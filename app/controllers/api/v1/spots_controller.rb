require 'grab/weather_cn'
class Api::V1::SpotsController < ApplicationController
	before_action :authenticate_with_token, only: [:destroy]
	def show
		respond_with spot = Spot.find(params[:id])
	end

	def create
	    if current_user
		    spot = current_user.spots.build(spot_params)
		else
		    spot = Spot.new(spot_params)
		end
		
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
		distance = params[:distance].to_i
		longitude = params[:lon].to_f
		latitude = params[:lat].to_f

		spots = Spot.near(longitude, latitude, distance).limit(10)
		weather = nil
		if area_id = params[:area_id]
			weather_cn = WeatherCn.new(area_id)
			weather = weather_cn.fetch_weather
		end

		render json: {spots: spots.as_json(include: { user: { only: [:_id, :avatar, :gender, :nick_name]} }, except: [:is_public, :user_id]), weather_cn: weather}
	end

	private
	def spot_params
	  attr = params.require(:spot).permit!
	end
end
