Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  mount StripeEvent::Engine, at: '/webhooks'

  namespace :api do
    namespace :v1 do
      resources :resumes
      resources :covers do
        post :pay
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
