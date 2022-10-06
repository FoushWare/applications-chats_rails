require "sidekiq/web"

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  # Routes REST API for the application
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :applications, only: [:index, :create, :show, :update, :destroy], param: :token
      resources :chats, only: [:index, :create, :show, :update, :destroy]
      resources :messages, only: [:index, :create, :show, :update, :destroy]
      # search route in messages
      get "messages/search/:query", to: "messages#search"
    end
  end
end
