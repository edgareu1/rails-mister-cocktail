Rails.application.routes.draw do
  root to: "cocktails#index"

  resources :cocktails do
    resources :doses, only: [:create, :destroy, :update]
    resources :reviews, only: [:create]
  end
end
