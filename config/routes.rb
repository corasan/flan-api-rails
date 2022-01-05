Rails.application.routes.draw do
  post '/signup', to: 'user#create'
  post '/login', to: 'user#login'

  get '/user/info', to: 'user_info#index'
  post '/user/info', to: 'user_info#create'
  put '/user/info', to: 'user_info#update'

  get '/expenses', to: 'expense#index'
  post '/expense', to: 'expense#create'
  put '/expense/:id', to: 'expense#update'

  get '/estimate', to: 'estimate#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
