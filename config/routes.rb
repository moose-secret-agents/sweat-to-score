Rails.application.routes.draw do
  get 'login' => 'user_sessions#new',       :as => 'login'
  get 'logout' => 'user_sessions#destroy',  :as => 'logout'
  get 'signup' => 'user_users#new',         :as => 'signup'

  get 'news/index' => 'news#index', as: 'news'

  get 'teams/index'
  get 'teams/show'

  resources :users do
    resources :teams, shallow: true
    get 'leagues' => 'leagues#user_index', as: 'leagues'
  end

  resources :leagues do
    resources :matches, except: [:edit, :update], shallow: true
  end

  root to: 'welcome#home'
end
