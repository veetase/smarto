class ShowController < ApplicationController
  def index
    heat_dots_names = ["hot_temp", "hot_hum", "hot_pm", "hot_v", "cold_temp", "cold_hum", "cold_pm", "cold_v"]
    dots = {}
    heat_dots_names.each do |h|
      dots[h] = JSON.load $redis.get(h)
    end

    render json: dots
  end

  def latest_spot
    user = User.where(phone: params[:phone]).first
    raise Api::ParameterInvalid unless user

    @latest_spot = Spot.where(user_id: user.id).order("created_at DESC").first
  end
end
