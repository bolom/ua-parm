Rails.application.routes.draw do
    root "plants#index"

   resources :families,  only: [:show, :index]

   resources :species,  only: [:show, :index] do
      resources :images
   end
   resources :genus,  only: [:show, :index]
   resources :names,  only: [:show]
   resources :plants,  only: [:show, :index, :edit, :update]
   resources :people
   resources :sources
   resources :citations
   resources :areas
   resources :taxa,  only: [:index]
   resources :images,  only: [:destroy, :update]

  end
