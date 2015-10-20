ActiveAdmin.register Voucher do
  actions :all
  filter :name
  filter :code
  filter :status, as: :select, collection: I18n.t("admin.voucher.statuses")
  filter :expire_at
  permit_params :name, :description, :type, :ex_count, :expire_at, :status

  action_item :view, only: :index do
    link_to 'Produce Vouchers', produce_vouchers_admin_vouchers_path
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :name
      f.input :type, as: :select, collection: {Single: 'Vouchers::Single', Online: 'Vouchers::Template', Offline: 'Vouchers::Offline'}
      f.input :status, as: :select, collection: {Fresh: Voucher::Status::FRESH, Used: Voucher::Status::USED, Disable: Voucher::Status::DISABLED}
      f.input :ex_count
      f.input :expire_at, :as => :datepicker
    end
    f.actions
  end

  collection_action :produce_vouchers, method: [:get, :post] do
    if request.post?
      count = params['count']
      voucher = Voucher.new(permitted_params[:voucher])
      voucher.status = Voucher::Status::FRESH
      voucher.generate_by_count(count)

      redirect_to admin_vouchers_path, notice: "Vouchers have been successfully produced!"
    else
      render :produce_vouchers
    end
  end
end
