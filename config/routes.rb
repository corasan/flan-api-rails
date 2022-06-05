Rails.application.routes.draw do
  get '/', to: 'general#index'
  post '/signup', to: 'registration#create'
  post '/login', to: 'user#login'
  get '/user', to: 'user#index'

  get '/user/info', to: 'user_info#index'
  post '/user/info', to: 'user_info#create'
  put '/user/info', to: 'user_info#update'

  get '/user/estimates', to: 'estimate#index'
  get '/user/estimate/checking', to: 'estimate#estimate_checking'
  get '/user/estimate/chart', to: 'estimate#chart'

  get '/expenses', to: 'expense#index'
  post '/expense', to: 'expense#create'
  put '/expense/:id', to: 'expense#update'
  delete '/expense/:id', to: 'expense#destroy'

  post '/auth/refresh_token', to: 'refresh_token#index'

  namespace :v2 do
    resources :signup
    resources :login
    resources :expense, except: :index
    get '/expenses', to: 'expense#index'
    delete '/expense', to: 'expense#destroy'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
