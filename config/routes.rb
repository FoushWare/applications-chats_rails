Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Routes REST API for the application
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :applications, only: [:index, :create, :show, :update, :destroy]
      resources :chats, only: [:index, :create, :show, :update, :destroy]
      resources :messages, only: [:index, :create, :show, :update, :destroy]
    end
  end
end
