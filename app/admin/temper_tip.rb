ActiveAdmin.register TemperTip do
  active_admin_importable
  actions :all

  before_create do |tip|
    tip.user = current_user
  end

  permit_params do
    permitted = [:temper, :tip, :month_related_to, :location_related_to, :tags, :user_id]
    permitted
  end
end
