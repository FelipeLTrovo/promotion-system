Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#index'

  resources :promotions, only: %i[index show new create edit update destroy] do
    member do
      post 'generate_coupons'
      post 'approve'
    end
    get 'search', on: :collection
  end

  resources :product_categories, only: %i[index show new create edit update destroy] do
    get 'search', on: :collection
  end

  resources :coupons, only: %i[show] do
    post 'disable', on: :member
    post 'enable', on: :member
    get 'search', on: :collection
  end

  namespace :api, constraints: ->(req) { req.format == :json } do
    namespace :v1 do
      resources :coupons, only: %i[show], param: :code
      resources :product_categories, only: %i[show create update destroy], param: :code
        
    end
  end

end
