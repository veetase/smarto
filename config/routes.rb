require 'constraints/api_constraints'
require 'sidekiq/web'

Rails.application.routes.draw do
  root 'static#index'
  get 'static/shengmaodou', to: 'static#shengmaodou'
  get 'beijing_show', to: 'show#index'
  ActiveAdmin.routes(self)
  mount Sidekiq::Web => '/sidekiq'
  resources :subscribers

  namespace :api, defaults: {format: :json}, path: '/', constraints: { subdomain: 'api' } do
    scope module: :v3, constraints: ApiConstraints.new(version: 3) do
      resources :users, :only => [:create] do
        collection do
          get 'check_phone/:phone', :action => 'check_phone'
          post 'verify_confirm', action: :verify_confirm
        end
      end

      get 'weather/realtime/:area_id', to: 'weather#realtime'
    end

    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
      get 'splash', to: 'splash#current'
      resources :temper_tips, only: [:index] do
        collection do
          get 'updated_at', action: :updated_at
        end
      end
      resources :spots, :only => [:create, :destroy] do
        member do
          get ':type', :action => :show
          post 'like/:type', :action => :like
          post 'unlike/:type', :action => :unlike
        end
        collection do
          get 'around/:area_id/:lon/:lat/:distance', :action => 'around', :constraints => {:lon => /\-*\d+.\d+/ , :lat => /\-*\d+.\d+/}
        end
        resources :comments do
          collection do
            get ':type/page/:page', :action => :index
            post ':type', :action => :create
          end
        end
      end
    end
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      resources :passwords, :only => [:create] do
        put 'reset', on: :collection
      end
      resources :users, :only => [:create, :update, :show] do
        collection do
          get 'change_phone'
          put 'reset_phone'
          get 'check_phone/:phone', :action => 'check_phone'
        end
      end
      resources :sessions, :only => [:create] do
        collection do
          delete 'logout'
        end
      end
      resources :spots, :only => [:show, :create, :destroy] do
      	collection do
      	  get 'around/:area_id/:lon/:lat/:distance', :action => 'around', :constraints => {:lon => /\-*\d+.\d+/ , :lat => /\-*\d+.\d+/}
      	end

        member do
          post 'like'
          post 'unlike'
        end

        resources :spot_comments, only: [:index, :create] do
          get 'page/:page', :action => :index, :on => :collection
        end
      end
      get 'qiniu_token/:bucket', to: 'qiniu_token#create'
      post 'vouchers/:voucher', to: 'vouchers#active'
      get 'vouchers', to: 'vouchers#index'
      resources :products, :only => [:show, :index]
      resources :addresses
      resources :orders, :only => [:show, :create, :update, :destroy] do
        member do
          get 'get_charge'
          post 'complete_order'
          post 'cancel'
        end
      end
    end
  end

  devise_for :users, :controllers => {:confirmations => "devise_overrides/confirmations", :registrations=> "devise_overrides/registrations"}
end
