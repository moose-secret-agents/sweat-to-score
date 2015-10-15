Rails.application.routes.draw do

  resources :users do
    resources :teams, shallow: true
    get 'leagues' => 'leagues#user_index'
  end

  resources :leagues do
    resources :matches, except: [:edit, :update], shallow: true
  end

  root to: 'welcome#home'
end
