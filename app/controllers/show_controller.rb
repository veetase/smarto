require 'grab/weather_cn'
class ShowController < ApplicationController
  def index
    heat_map_names = ["beijing_a", "beijing_as", "beijing_apm", "beijing_av",
                      "beijing_b", "beijing_bs", "beijing_bpm", "beijing_bv",
                      "beijing_c", "beijing_cs", "beijing_cpm", "beijing_cv",
                      "beijing_d", "beijing_ds", "beijing_dpm", "beijing_dv",
                      "shenzhen_a", "shenzhen_as", "shenzhen_apm", "shenzhen_av",
                      "shenzhen_b", "shenzhen_bs", "shenzhen_bpm", "shenzhen_bv",
                      "shenzhen_c", "shenzhen_cs", "shenzhen_cpm", "shenzhen_cv"]
    map = {}
    heat_map_names.each do |h|
      map[h] = JSON.load $redis.get(h)
    end

    render json: map
  end
end
