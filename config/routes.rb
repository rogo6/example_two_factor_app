Rails.application.routes.draw do
  devise_for :users
  root "root#index"

  resources :secret, only: :index
end
