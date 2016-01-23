ActiveAdmin.register Splash do
  permit_params :name, :url, :description, :picture, :begin_at, :end_at, :on, :model

  index do
    id_column
    column "name" do |splash|
      link_to(splash.name, splash.url)
    end

    column :description
    column :begin_at
    column :end_at
    column :picture do |splash|
      qiniu_image_tag(splash.picture.url)
    end
    actions
  end

  form do |f|
    f.inputs "Project Details" do
      f.input :name
      f.input :description
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
      row :description
      row :thumbnail do
        qiniu_image_tag(s.picture.url(:thumb))
      end
      # Will display the image on show object page
    end
   end
end
