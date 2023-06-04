Rails.application.routes.draw do
  root :to => 'documents#index'

  resources :documents
  resources :users, :only => [:index, :destroy, :create, :edit, :update]

  get '/signup' => 'users#new'
  patch '/documents/:id/update_column', to:'documents#update_column' 
  get '/shared_view', to: 'documents#shared_view'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get "*path", :to => redirect('/')
end
