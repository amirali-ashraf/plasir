Rails.application.routes.draw do
  root 'stores#index'
  resources :stocks
  resources :shoe_models
  resources :stores
  
  get '/health_check', to: proc { [200, {}, ['success']] }

  post "/stocks/move" => "stocks#move"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :feeds, only: [:index, :show, :create]
    end
  end
end
