Rails.application.routes.draw do
  get 'login' => 'user_sessions#new',       :as => 'show_login'
  post 'login' => 'user_sessions#create',   :as => 'login'
  get 'logout' => 'user_sessions#destroy',  :as => 'logout'
  get 'signup' => 'users#new',              :as => 'signup'

  get 'news/index' => 'news#index', as: 'news'

  get 'teams/index'
  get 'teams/show'

  resources :users do
    resources :teams, shallow: true do
      post 'train', to: 'tokens#train', on: :member
      post 'positions', to: 'teams#positions', on: :member
    end

    get 'tokens', to: 'tokens#index', as: 'tokens'
    post 'tokens/book', to: 'tokens#book', as: 'book_tokens'
    get 'leagues' => 'leagues#user_index', as: 'leagues'
    get 'partnerships' => 'partnerships#user_index', as: 'partnerships'
  end

  resources :leagues do
    put 'start', to: 'leagues#start', on: :member
    put 'stop', to: 'leagues#stop', on: :member
    resources :matches, except: [:edit, :update], shallow: true
  end

  resources :partnerships do
    put 'accept', to: 'partnerships#accept', on: :member
    put 'refuse', to: 'partnerships#refuse', on: :member
    put 'cancel', to: 'partnerships#cancel', on: :member
  end

  resources :team_invitations do
    put 'accept', to: 'team_invitations#accept', on: :member
    put 'refuse', to: 'team_invitations#refuse', on: :member
  end

  resources :league_invitations do
    put 'accept', to: 'league_invitations#accept', on: :member
    put 'refuse', to: 'league_invitations#refuse', on: :member
  end

  root to: 'news#index'
end
