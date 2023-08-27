Rails.application.routes.draw do
  devise_for :users,controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }
  resources :users, only: [:edit, :update]
  resources :secrets, only: :index

  authenticated :user do
    root to: 'secrets#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'users/sessions#new', as: :unauthenticated_root
  end
end
