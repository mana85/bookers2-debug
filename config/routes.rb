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
    resource :relationships, only: [:create, :destroy]
    get 'list_of_followed' => 'relationships#list_of_followed', as: 'list_of_followed'
    get 'list_of_followers' => 'relationships#list_of_followers', as: 'list_of_followers'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
