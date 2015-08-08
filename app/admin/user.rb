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

  collection_action :user_report, method: :post do
    opts = {start_date: params[:start_date], end_date: params[:end_date]}
    reports = {}
    ["signups", "spots", "comments", "likes", "tel_attributions"].map{|item| reports[item] = Report.find(item, opts).as_json}
    render json: reports.as_json
  end

end
