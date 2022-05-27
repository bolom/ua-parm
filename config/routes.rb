Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
resources :plants
root "plants#index"
  # Defines the root path route ("/")
  # root "articles#index"
end
