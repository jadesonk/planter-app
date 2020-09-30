Rails.application.routes.draw do
  get 'conversations/index'
  devise_for :users
  root to: 'listings#index'

  post '/listings/filter', to: 'listings#filter', as: 'listings_filter'
  resources :listings, only: %i[index show new create] do
    resources :messages, only: [:create]
  end

  resources :conversations, only: %i[index show] do
    resources :messages, only: [:create]
  end

  resources :plants, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  get "/search", to: "plants#slug_index"
  get "/search/:slug", to: "plants#slug_show", as: "slug_plant"
  get "/stories", to: "plants#collection"
end