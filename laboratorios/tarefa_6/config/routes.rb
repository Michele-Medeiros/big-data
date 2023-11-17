# frozen_string_literal: true

Rails.application.routes.draw do
  root :to => 'users#index'
  # resources :users
  resources :users do
    collection do
      post :search  # creates a route called users_search
    end
  end
  match '*unmatched', to: 'application#not_found_method', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
