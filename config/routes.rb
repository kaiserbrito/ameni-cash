# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :products, only: %i[index] do
    post :add_to_cart, on: :member, as: :add_to_cart
  end
  root to: "products#index"

  resources :carts do
    delete 'remove_product/:cart_product_id', to: 'carts#remove_product', as: 'remove_cart_product'
  end
end
