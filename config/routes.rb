require 'constraints/api_constraints'
require 'sidekiq/web'

Rails.application.routes.draw do
  root 'static#index'
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, :controllers => {:confirmations => "devise_overrides/confirmations", :registrations=> "devise_overrides/registrations"}
  resources :subscribers
  namespace :api, defaults: {format: :json}, path: '/', constraints: { subdomain: 'api' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :passwords, :only => [:create] do
        put 'reset', on: :collection
      end
      resources :users, :only => [:update, :show] do
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
      resources :spots do
      	collection do
      	  get 'around/:area_id/:lon/:lat/:distance', :action => 'around', :constraints => {:lon => /\-*\d+.\d+/ , :lat => /\-*\d+.\d+/}
      	end
      end
      get 'qiniu_token/:bucket', to: 'qiniu_token#create'
    end
  end
end
