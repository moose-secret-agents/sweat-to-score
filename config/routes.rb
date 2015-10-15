Rails.application.routes.draw do

  get 'teams/index'

  get 'teams/show'

  get 'news/index' => 'news#index', as: 'news'

  resources :users do
    resources :teams, shallow: true
    get 'leagues' => 'leagues#user_index', as: 'leagues'
  end

  resources :leagues do
    resources :matches, except: [:edit, :update], shallow: true
  end

  root to: 'welcome#home'
end
