Rails.application.routes.draw do
  devise_for :users
  root to: 'listings#index'

  post '/listings/filter', to: 'listings#filter', as: 'listings_filter'
  resources :listings, only: %i[index show new create]

  resources :plants, only: [:index, :new, :create, :show]
  get "/search", to: "plants#slug_index"
  get "/search/:slug", to: "plants#slug_show", as: "slug_plant"
  get "/stories", to: "plants#collection"
end