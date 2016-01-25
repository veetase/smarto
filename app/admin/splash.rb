ActiveAdmin.register Splash do
  permit_params :name, :url, :slogan, :description, :picture, :begin_at, :end_at, :on, :model

  index do
    id_column
    # column :name
    # column :slogan
    # column :description
    column :url do |s|
      link_to(s.url, s.url)
    end
    column :begin_at
    column :end_at
    column :picture do |splash|
      qiniu_image_tag(splash.picture.url, size: "50x50")
    end
    actions
  end

  form do |f|
    f.inputs "Project Details" do
      f.input :name
      f.input :description
      f.input :slogan
      f.input :url
      f.input :begin_at, :as => :datepicker
      f.input :end_at, :as => :datepicker
      f.input :picture, :required => true, :as => :file
      # Will preview the image when the object is edited
    end
    f.actions
   end

  show do |s|
    attributes_table do
      row :name do
        link_to(s.name, s.url)
      end
      row :slogan
      row :description
      row :thumbnail do
        qiniu_image_tag(s.picture.url(:thumb))
      end
      # Will display the image on show object page
    end
   end
end
