require 'devise_token_auth'

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :items, only: [:create, :update, :destroy]
      resources :purchase, only: [:create]
    end
  end
end
