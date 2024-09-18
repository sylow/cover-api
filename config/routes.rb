Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount StripeEvent::Engine, at: '/webhooks'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :resumes
      resources :covers do
        post :run
      end
      resources :transactions
      resources :sessions do
        get :refresh, on: :collection
      end
      resources :users
      resources :me, only: :index
    end
  end
end
