require 'constraints/api_constraints'
Rails.application.routes.draw do
  root 'bixuange#index'
  devise_for :users, :controllers => {:confirmations => "confirmations"}
  resources :subscribers
  
  namespace :api, defaults: {format: :json}, constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users
      resources :sessions, :only => [:create, :destroy]
      resources :spots do
      	collection do
      	  get 'around'
      	end
      end
    end
  end
end
