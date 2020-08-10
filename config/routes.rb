Rails.application.routes.draw do
  root to: "cocktails#index"

  resources :cocktails do
    resources :doses, only: [:create]
    resources :reviews, only: [:create]
  end

  resources :doses, only: [:destroy, :update]
end
