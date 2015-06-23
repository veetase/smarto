ActiveAdmin.register Spot do
  permit_params :status
  actions :all, except: [:destroy, :create, :new]
  sidebar :map, only: :index do
    render :partial => "/admin/map", :locals => {spots: @spots }
  end
  index do
    selectable_column
    id_column
    column "Image" do |spot|
      image_tag spot.image, class: 'thumb'
    end
    column :comment
    column("Status") { |spot| status_tag (I18n.t("admin.spot.statuses")[spot.status])}
    column :created_at
    column "Uploader" do |spot|
      spot.user.nick_name if spot.user
    end
    actions
  end

  batch_action :reject do |ids|
    batch_action_collection.find(ids).each do |spot|
      spot.reject
    end

    redirect_to collection_path, alert: "The spots have been rejected."
  end



  batch_action :activate do |ids|
    batch_action_collection.find(ids).each do |spot|
      spot.activate
    end

    redirect_to collection_path, alert: "The spots have been activated."
  end

  form do |f|
    inputs 'Comment' do
      content_tag(f.object.comment)
    end

    inputs 'temperatures' do
      input :max_temperature, label: "Max"
      input :min_temperature, label: "Min"
    end

    inputs 'Image' do
      image_tag(f.object.image, class: "image_normal")
    end

    panel 'Markup' do
      "The spot can be reject if its content containt any bad information"
    end

    f.input :status, :as => :radio, :collection => {"published": 0, "reject": 1}, include_blank: false
    para "Press cancel to return to the list without saving."
    actions
  end

  filter :is_public
  filter :created_at
  filter :user_nick_name, as: :string
  filter :comment

  scope :published
end
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
