Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root 'home#index'
  # resource :buildings
  # get 'buildings', to: 'buildings#index'
  # get 'buildings/:id', to: 'buildings#show'
  
  resources :buildings
end
