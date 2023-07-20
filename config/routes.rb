Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"

  resources :chats, only: %i[create show] do
    resources :messages, only: %i[create]
  end
end
