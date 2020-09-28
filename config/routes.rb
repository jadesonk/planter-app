Rails.application.routes.draw do
  devise_for :users
  root to: 'listings#index'

  post '/listings/filter', to: 'listings#filter', as: 'listings_filter'
  resources :listings, only: %i[index show new create]

  resources :plants, only: [:index]
  get "/plants/:slug", to: "plants#show", as: "plant"


  get "/questions", to: "questions#index", as: "questions"


end
