require 'grab/weather_cn'
class Api::V1::SpotsController < ApplicationController
	before_action :authenticate_with_token, only: [:destroy]
	before_action :get_spot, only: [:like, :unlike, :show]

	def show
		@spot.add_view_count
		respond_with @spot.as_json(include: {user: { only: [:id, :avatar, :gender, :nick_name]}}, except: [:is_public, :user_id])
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
		limit_count = 100
		limit_days = 7

		case distance
		when 0..5000
			limit_count = 10
		when 5001..500000
			limit_count = 50
		end

		spots = Spot.includes(:comments, :user).near(longitude, latitude, distance).where("created_at > ?", limit_days.days.ago ).order("created_at DESC").limit(limit_count)
		station_spots = nil
		if params[:area_id] == "101280601"
			station_spots = StationSpot.near(longitude, latitude, distance).where("created_at >= ?", 15.minutes.ago).order("created_at DESC").limit(limit_count)
		end

		render json: {spots: spot_public_list(spots), station_spots: station_spots}
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

	def spot_public_list(spot)
		spot.as_json(include: [{spot_comments: {only: [:id, :content, :created_at], include: {user: {only: [:id, :avatar, :gender, :nick_name]}}}}, {user: { only: [:id, :avatar, :gender, :nick_name]}}], except: [:is_public, :user_id])
	end
end
