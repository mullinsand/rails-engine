Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/merchants/find', controller: "merchants", action: "find", as: :merchant_find
      get '/merchants/find_all', controller: 'merchants', action: 'find_all', as: :merchants_find
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchant/items'
      end
      get '/items/find', controller: "items", action: "find", as: :item_find
      get '/items/find_all', controller: 'items', action: 'find_all', as: :items_find
      resources :items do
        resource :merchant, only: [:show], controller: 'item/merchant'
      end
    end
  end
end
