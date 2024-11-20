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
        post :verify_email, on: :collection
      end

      resources :me do
        post :send_verification_email, on: :collection
      end
      resources :packages, only: :index
      resources :password_resets, param: :token
    end
  end
end
