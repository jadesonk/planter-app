Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :listings, only: %i[index show new create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :plants, only: [:index ]
  get "/plants/:slug", to: "plants#show", as: "plant"


  get "/questions", to: "questions#index", as: "questions"


end
