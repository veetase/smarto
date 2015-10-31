class Api::V2::SpotsController < ApplicationController
	include Api::V2::Concerns::FindSpot
	before_action :authenticate_with_token, only: [:destroy]
	before_action only: [:like, :unlike] do
		get_spot(params[:id])
	end

	#in action show, like, unlike, spot can be user spot and station spot
	def show
		if params[:type] == "station_spot"
			@spot = StationSpot.find(params[:id])
			@spot.add_view_count
			respond_with @spot.as_json
		else
			@spot = Spot.includes(:user).find(params[:id])
			@spot.add_view_count
			respond_with @spot.as_json(include: {user: {only: [:id, :avatar, :gender, :nick_name]}}, except: [:is_public, :user_id])
		end
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
			station_spots = StationSpot.near(longitude, latitude, distance).where("created_at >= ?", 60.minutes.ago).order("created_at DESC").limit(limit_count)
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

	def spot_public_list(spot)
		if spot.model_name.name.underscore == "spot"
			spot.as_json(include: [{comments: {only: [:id, :content, :created_at], include: {user: {only: [:id, :avatar, :gender, :nick_name]}}}}, {user: { only: [:id, :avatar, :gender, :nick_name]}}], except: [:is_public, :user_id])
		else
			spot.as_json(include: {comments: {only: [:id, :content, :created_at], include: {user: {only: [:id, :avatar, :gender, :nick_name]}}}})
		end
	end
end
