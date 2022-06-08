Rails.application.routes.draw do
    resources :plants
    resources :names
    resources :people
    resources :sources
    resources :citations
    resources :areas

    root "plants#index"
  end
