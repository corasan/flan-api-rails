Rails.application.routes.draw do
  get '/user', to: 'user#index'
  post '/user', to: 'user#create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
