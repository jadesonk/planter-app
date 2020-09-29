Rails.application.routes.draw do
  devise_for :users
  root to: 'listings#index'

  post '/listings/filter', to: 'listings#filter', as: 'listings_filter'
  resources :listings, only: %i[index show new create]

  resources :plants, only: [:index]
  get "/plants/:slug", to: "plants#show", as: "plant"


  # get "/questions", to: "questions#index", as: "questions"
  # get "questions/new", to: "questions#new", as: "new_question"
  # post "/questions", to: "questions#create"
  # get "questions/:id", to: "questions#show", as: "question"
  # get "questions/:id/answers/new", to: "answers#new", as: "new_answer"

  resources :questions, only: %i[index show new create] do
    resources :answers, only: %i[new create]
  end
  resources :answers, only: %i[index]
end
