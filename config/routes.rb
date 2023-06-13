Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :projects, only: %i[index show new create edit update] do
    resources :buildings, only: %i[edit update]
    # resources :ground_types, only: %i[index edit]
    resources :working_well_systems, only: %i[index create show]
  end

  # resources :projects, only: %i[index show]

  resources :buildings, only: %i[new create update]
  # resources :working_well_systems, only: %i[index]
  # pour les admin de geocool :
  resources :ground_types, only: %i[new show create]


  # resources :manufacturers, only: %i[new create edit update]
  # resources :pipes, only: %i[new show create edit update]
  # resources :energetic_studies, only: %i[new show create edit update]
  # resources :energetic_results, only: %i[new create edit update]
  # resources :working_pipes, only: %i[new create edit update]
  # resources :studied_pipes, only: %i[new create edit update]
end
