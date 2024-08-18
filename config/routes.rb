Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :sessions do
        get :refresh, on: :collection
      end
      resources :users
    end
  end
end
