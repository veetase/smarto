ActiveAdmin.register User do
  permit_params :locked_at, roles:[]
  actions :all, except: [:destroy, :new, :create]
  index do
    selectable_column
    id_column
    column :nick_name
    column :phone
    column :last_sign_in_at
    column :created_at
    actions
  end

  filter :phone
  filter :nick_name
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :nick_name, :input_html => { :disabled => true }
      f.input :roles, :as => :select, :collection => {"admin" => :admin, "QA" => :QA}, multiple: true
      f.input :locked_at, :as => :datepicker
    end
    f.actions
  end

end
