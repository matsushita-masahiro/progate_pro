Rails.application.routes.draw do
  
  post 'likes/:post_id/destroy' => 'likes#destroy'
  post 'likes/:post_id/create' => 'likes#create'
  
  get "login" => "users#login_form"
  post "login" => "users#login"
  post "logout" => "users#logout"

  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get "users/index" => "users#index"
  get "users/:id" => "users#show"
  get "users/:id/likes" => "users#likes"
  get "users/:id/quit_confirm" => "users#quit_confirm"
  post "users/:id/destroy" => "users#destroy"
  post "users/:id/follow_request" => "users#follow_request"
  

  get "posts/index" => "posts#index"
  get "posts/new" => "posts#new"
  get "posts/:id" => "posts#show"
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"
  
  resources :posts do
    resources :comments, only: [:index, :create, :destroy, :update], shallow: true
  end


  
  get "/" => "home#top"
  get "about" => "home#about"
  
end
