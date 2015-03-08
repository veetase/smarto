class Api::V1::SpotsController < ApplicationController
	before_action :authenticate_with_token, only: [:create]
	def show
		respond_with spot = Spot.find(params[:id])
	end

	def create
		spot = current_user.spots.build(spot_params)
		if spot.save
      		render json: spot, status: 201, location: [:api, spot]
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
		spots = Spot.geo_near([params[:x].to_i, params[:y].to_i]).max_distance(params[:distance].to_i).spherical
		render json: spots
	end

	private
	def spot_params
	  attr = params.require(:spot).permit!
	  attr["location"]["coordinates"] = attr["location"]["coordinates"].collect{|x| x.to_i} if attr["location"]
	  return attr
	end
end
