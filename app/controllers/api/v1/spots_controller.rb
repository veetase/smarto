require 'grab/weather_cn'
class Api::V1::SpotsController < ApplicationController
	before_action :authenticate_with_token, only: [:destroy]
	before_action :get_spot, only: [:show, :like, :unlike]

	def show
		@spot.add_view_count
		respond_with spot_public_list(@spot)
	end

	def create
	  if current_app_user
		    spot = current_app_user.spots.build(spot_params)
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
	    spot = current_app_user.spots.find(params[:id])
	   	spot.destroy
	    head 204
	end

	def around
		distance = params[:distance].to_i
		longitude = params[:lon].to_f
		latitude = params[:lat].to_f

		spots = Spot.near(longitude, latitude, distance).includes(:user)
		weather = nil
		if area_id = params[:area_id]
			weather_cn = WeatherCn.new(area_id)
			weather = weather_cn.fetch_weather
		end

		render json: {spots: spot_public_list(spots), weather_cn: weather}
	end

	def like
			@spot.like = @spot.like + 1
			head 204 if @spot.save
	end

	def unlike
		@spot.like = @spot.like - 1
		head 204 if @spot.save
	end

	private
	def spot_params
		params.require(:spot).except!(:like).permit!
	end

	def get_spot
		@spot = Spot.find(params[:id])
	end

	def spot_public_list(spots)
		spots.as_json(include: { user: { only: [:id, :avatar, :gender, :nick_name]} }, except: [:is_public, :user_id])
	end
end
