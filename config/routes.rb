Rails.application.routes.draw do
  post '/signup', to: 'user#create'
  post '/login', to: 'user#login'

  get '/user/info', to: 'user_info#index'
  post '/user/info', to: 'user_info#create'
  put '/user/info', to: 'user_info#update'

  get '/user/estimates', to: 'estimate#index'
  get '/user/estimate/checking', to: 'estimate#estimate_checking'

  get '/expenses', to: 'expense#index'
  post '/expense', to: 'expense#create'
  put '/expense/:id', to: 'expense#update'

  post '/auth/refresh_token', to: 'refresh_token#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
