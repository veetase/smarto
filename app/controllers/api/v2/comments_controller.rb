class Api::V2::CommentsController < ApplicationController
  include Api::V2::Concerns::FindSpot

  before_action do
    get_spot(params[:spot_id])
  end

  def index
    render json: @spot.comments.includes(:user).order(created_at: :desc).page(params[:page]).as_json(
      include: { user: { only: [:id, :avatar, :gender, :nick_name]} }
    )
  end

  def create
    comment = Comment.new(comment_params)
    comment.user = current_app_user if current_app_user

    @spot.comments.create!(comment.attributes)
    head 204
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
