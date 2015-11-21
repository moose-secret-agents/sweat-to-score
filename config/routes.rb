Rails.application.routes.draw do
  get 'login' => 'user_sessions#new',       :as => 'show_login'
  post 'login' => 'user_sessions#create',   :as => 'login'
  get 'logout' => 'user_sessions#destroy',  :as => 'logout'
  get 'signup' => 'users#new',              :as => 'signup'

  get 'news/index' => 'news#index', as: 'news'

  get 'partnerships/index'

  get 'teams/index'
  get 'teams/show'

  resources :users do
    resources :teams, shallow: true do
      post 'train', to: 'tokens#train', on: :member
    end

    get 'tokens', to: 'tokens#index', as: 'tokens'
    post 'tokens/book', to: 'tokens#book', as: 'book_tokens'
    get 'leagues' => 'leagues#user_index', as: 'leagues'
    get 'partnerships' => 'partnerships#user_index', as: 'partnerships'
  end

  resources :leagues do
    resources :matches, except: [:edit, :update], shallow: true
  end

  resources :partnerships do

  end

  root to: 'welcome#home'
end
