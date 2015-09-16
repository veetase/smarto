module Api::V1::Concerns::FindSpot
  def get_spot(id)
    @spot = nil

    if params[:type] == "station_spot"
      @spot = StationSpot.find(id)
    else
      @spot = Spot.find(id)
    end
  end
end
