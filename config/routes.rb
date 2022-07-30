Rails.application.routes.draw do

   resources :families,  only: [:show, :index]
   resources :species,  only: [:show, :index]
   resources :genus,  only: [:show, :index]
   resources :variety,  only: [:show, :index]
    resources :names,  only: [:show]
    resources :plants,  only: [:show, :index, :edit, :update]
    resources :people
    resources :sources
    resources :citations
    resources :areas

    resources :taxa,  only: [:index]

    root "plants#index"
  end
