require 'constraints/api_constraints'
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, :controllers => {:confirmations => "devise_overrides/confirmations", :registrations=> "devise_overrides/registrations"}
  resources :subscribers

  namespace :api, defaults: {format: :json}, path: '/'  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :passwords
      resources :sessions, :only => [:create] do
        collection do
          delete 'logout'
        end
      end
      resources :spots do
      	collection do
      	  get 'around'
      	end
      end
    end
  end
end
