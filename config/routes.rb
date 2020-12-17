require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  post 'locale/set', to: 'locale#update'

  resources :mounts, only: [:index, :show]

  get 'minions/dark_helmet'
  resources :minions, only: [:index, :show] do
    get :verminion, on: :collection
  end

  resources :orchestrions, only: [] do
    get :select, on: :collection
  end

  %i(orchestrions emotes bardings hairstyles armoires spells fashions).each do |resource|
    resources resource, only: [:index, :show] do
      post :add, :remove, on: :member
    end
  end

  resources :items, only: [] do
    post :add, :remove, on: :member
  end

  namespace :relics, as: :relic do
    get :weapons
    get :weapons_manual, path: 'weapons/manual', action: :manual_weapons
    get :armor
    get :tools
  end

  # Backwards compatibility for old relics URLs
  get 'relics', to: redirect('relics/weapons')
  get 'relics/gear', to: redirect('relics/armor')

  resources :tomestones, only: [] do
    collection do
      get :mythology, :soldiery, :law
    end
  end

  get 'yokai', to: 'yokai#index'

  get 'achievements/types', to: redirect('404')
  get 'achievements/types/:id', to: 'achievements#type', as: :achievement_type
  get 'achievements/items', to: 'achievements#items', as: :achievement_items
  resources :achievements, only: [:index, :show]

  resources :characters, only: [:show, :destroy] do
    get :search, :profile, on: :collection
    post :select, on: :member
    get 'stats/recent', on: :member, to: 'characters#stats_recent', as: :stats_recent
    get 'stats/rarity', on: :member, to: 'characters#stats_rarity', as: :stats_rarity
  end

  resources :titles, only: :index

  resources :leaderboards, only: :index do
    collection do
      get 'fc/:id', as: :free_company, action: :free_company
    end
  end

  get   'settings',           to: 'settings#edit'
  patch 'settings/user',      to: 'settings#update_user',      as: :user_settings
  patch 'settings/character', to: 'settings#update_character', as: :character_settings
  get   'settings/user',      to: redirect('settings')
  get   'settings/character', to: redirect('settings')

  get 'character/verify',     to: 'characters#verify',   as: :verify_character
  post 'character/refresh',   to: 'characters#refresh',  as: :refresh_character
  post 'character/validate',  to: 'characters#validate', as: :validate_character
  delete 'character/forget',  to: 'characters#forget',   as: :forget_character
  delete 'character/comparison/forget', to: 'characters#forget_comparison', as: :forget_character_comparison

  namespace :api do
    resources :characters, only: :show
    resources :users, only: :show

    %i(achievements titles mounts minions orchestrions emotes bardings hairstyles armoires spells fashions).each do |resource|
      resources resource, only: [:index, :show]
    end
  end

  post 'discord/interactions'

  namespace :admin do
    resources :users, only: :index

    resources :characters, only: :index do
      delete :unverify, on: :member
    end

    resources :versions, only: [] do
      post :revert
    end

    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  namespace :mod do
    %i(mounts minions orchestrions emotes bardings hairstyles armoires spells fashions).each do |resource|
      resources resource, only: [:index, :edit, :update]
    end

    resources :sources, only: :destroy
    get 'dashboard', action: :index
  end

  get 'parasols', to: redirect('images/parasols.png')
  get 'commands', to: redirect('https://discord.com/oauth2/authorize?&client_id=788756679646904331&scope=applications.commands')

  get '404', to: 'home#not_found', as: :not_found
  match "api/*path", via: :all, to: -> (_) { [404, { 'Content-Type' => 'application/json' },
                                              ['{"status": 404, "error": "Not found"}'] ] }
  match "*path", via: :all, to: redirect('404')

  root 'home#index'
end
