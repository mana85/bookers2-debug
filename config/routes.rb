Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  devise_for :users
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resource :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
    get "search", to: "users#search"
  end

  resources :messages, only: [:create]
  resources :rooms, only: [:create, :index, :show]
  resources :groups do
    get "join" => "groups#join"
  end

  get "search" => "searches#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
