Rails.application.routes.draw do
    resources :plants do
      resources :names
    end

    resources :names
    resources :people
    resources :sources
    resources :citations
    resources :areas

    resources :taxa,  only: [:index]

    root "plants#index"
  end
