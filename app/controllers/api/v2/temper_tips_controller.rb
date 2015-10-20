class Api::V2::TemperTipsController < ApplicationController
  def index
    render json: TemperTip.all
  end

  def updated_at
    render json: TemperTip.last.updated_at
  end
end
