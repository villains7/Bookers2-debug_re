Rails.application.routes.draw do
  get 'chats/show'
  get 'relationships/create'
  get 'relationships/destroy'
  get 'searches/search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  get '/search', to: 'searches#search'
  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
  resource :favorites, only: [:create,:destroy]
  resources :book_comments, only: [:create,:destroy]
  end
  resources :users, only: [:index,:show,:edit,:update]do
    resource :relationships,only: [:create,:destroy]
  get 'followings' => 'relationships#followings',as: 'followings'
  get 'followers' => 'relationships#followers',as: 'followers'
  end
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:index,:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
