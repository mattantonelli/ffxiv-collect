require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  post 'locale/set', to: 'locale#update'

  get 'mounts/pickorpokkur'
  resources :mounts, only: [:index, :show]

  get 'minions/dark_helmet'
  resources :minions, only: [:index, :show] do
    get :verminion, on: :collection
  end

  resources :orchestrions, only: [] do
    get :select, on: :collection
  end

  resources :spells, only: [] do
    get :battle, on: :collection
  end

  get 'orchestrions/fool', to: redirect('images/fool.png')
  %i(orchestrions emotes bardings hairstyles armoires spells fashions records).each do |resource|
    resources resource, only: [:index, :show] do
      post :add, :remove, on: :member
    end
  end

  namespace :relics, as: :relic do
    get :weapons
    get :armor
    get :tools
  end

  resources :relics, as: :relic, only: [] do
    post :add, :remove, on: :member
  end

  # Backwards compatibility for old relics URLs
  get 'relics', to: redirect('relics/weapons')
  get 'relics/gear', to: redirect('relics/armor')
  get 'relics/weapons/manual', to: redirect('relics/weapons')

  resources :tomestones, only: [:index, :show]

  resources :p2w, only: :index

  get 'yokai', to: 'yokai#index'

  get 'achievements/types', to: redirect('404')
  get 'achievements/types/:id', to: 'achievements#type', as: :achievement_type
  get 'achievements/items', to: 'achievements#items', as: :achievement_items
  get 'achievements/search', to: 'achievements#search', as: :achievement_search
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

  get 'commands', to: 'static#commands'
  get 'faq', to: 'static#faq'

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

    %i(achievements titles mounts minions orchestrions emotes bardings hairstyles armoires spells fashions records relics)
      .each do |resource|
      resources resource, only: [:index, :show]
    end
  end

  get 'api/docs', to: redirect('https://documenter.getpostman.com/view/1779678/TzXzDHM1')

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
    %i(mounts minions orchestrions emotes bardings hairstyles armoires spells fashions records).each do |resource|
      resources resource, only: [:index, :edit, :update]
    end

    resources :sources, only: :destroy
    get 'dashboard', action: :index
  end

  get 'parasols', to: redirect('images/parasols.png')

  get '404', to: 'static#not_found', as: :not_found
  match "api/*path", via: :all, to: -> (_) { [404, { 'Content-Type' => 'application/json' },
                                              ['{"status": 404, "error": "Not found"}'] ] }
  match "*path", via: :all, to: redirect('404')

  # Quick 404 for missing images
  scope format: true, constraints: { format: 'png' } do
    get "/*missing", to: proc { [404, {}, ['']] }
  end

  root 'static#home'
end
