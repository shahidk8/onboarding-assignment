Rails.application.routes.draw do
  root :to => 'documents#index'

  resources :documents, :except => [:edit, :put]
  resources :users, :only => [:index, :destroy, :create]

  get '/signup' => 'users#new'
  put '/add_admin/:id' => 'users#a_admin'
  put '/delete_admin/:id' => 'users#d_admin'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  get "*path", :to => redirect('/')
end
