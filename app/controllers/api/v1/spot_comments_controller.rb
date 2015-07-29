class Api::V1::SpotCommentsController < ApplicationController
  before_action :get_spot
  def index
    render json: @spot.spot_comments.order(created_at: :desc).page(params[:page]).as_json(
      include: { user: { only: [:id, :avatar, :gender, :nick_name]} }
    )
  end

  def create
    spot_comment = SpotComment.new(spot_params)
    spot_comment.spot = @spot
    spot_comment.user = current_app_user if current_app_user

    head 204 if spot_comment.save
  end

  private
  def get_spot
    @spot = Spot.find(params[:spot_id])
  end

  def spot_params
    params.require(:spot_comment).permit(:content)
  end
end