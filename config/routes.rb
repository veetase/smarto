require 'constraints/api_constraints'
Rails.application.routes.draw do
  devise_for :users, :controllers => {:confirmations => "devise_overrides/confirmations", :sessions => "devise_overrides/sessions", :registrations=> "devise_overrides/sessions"}
  resources :subscribers

  namespace :api, defaults: {format: :json}, path: '/'  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      #resources :users
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
