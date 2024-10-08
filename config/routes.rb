Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount StripeEvent::Engine, at: '/webhooks'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :resumes do
        post :enhance
      end

      resources :covers do
        post :run
      end
      resources :transactions
      resources :sessions do
        get :refresh, on: :collection
      end

      resources :users do
        post :forgot, on: :collection
      end

      resources :me, only: :index
      resources :packages, only: :index
      resources :password_resets
    end
  end
end
