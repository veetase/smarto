class Api::V1::CommentsController < ApplicationController
  include Api::V1::Concerns::FindSpot

  before_action do
    get_spot(params[:spot_id])
  end

  def index
    render json: @spot.comments.includes(:user).order(created_at: :desc).page(params[:page]).as_json(
      include: { user: { only: [:id, :avatar, :gender, :nick_name]} }
    )
  end

  def create
    spot_comment = Comment.new(spot_params)
    spot_comment.user = current_app_user if current_app_user

    @spot.comments.create!(spot_comment.attributes)
    head 204
  end

  private
  def spot_params
    params.require(:spot_comment).permit(:content)
  end
end
