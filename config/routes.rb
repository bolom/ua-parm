Rails.application.routes.draw do
    resources :plants
    resources :names
    resources :people
    resources :sources
    root "plants#index"
  end
