Rails.application.routes.draw do
  devise_for :users,controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }

  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  resources :users, only: [:edit, :update]
  resources :secrets, only: :index

  authenticated :user do
    root to: 'secrets#index', as: :authenticated_root
  end

  devise_scope :user do
    root to: 'users/sessions#new', as: :unauthenticated_root
    get '/users/sign_in/otp' => 'users/otp/auth#new'
    post '/users/otp/regenerate' => 'users/sessions#regenerate_two_factor_code'
    post '/users/sign_in/otp' => 'users/otp/auth#create'
  end
end
