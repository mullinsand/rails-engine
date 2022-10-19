Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/merchants/find', controller: "merchants/search", action: "find", as: :merchant_find
      get '/merchants/find_all', controller: 'merchants/search', action: 'find_all', as: :merchants_find
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
      get '/items/find', controller: "items/search", action: "find", as: :item_find
      get '/items/find_all', controller: 'items/search', action: 'find_all', as: :items_find
      resources :items do
        resource :merchant, only: [:show], controller: 'items/merchant'
      end
    end
  end
end
