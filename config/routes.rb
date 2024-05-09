require 'sidekiq/web'

Rails.application.routes.draw do
  # Authentication
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # Memes
  resources :battle_pass, only: :index
  resources :p2w, only: [:index, :show]
  resources :endless, only: [:index]
  get 'fish', to: redirect('minions/396')
  get 'minions/dark_helmet'
  get 'mounts/pickorpokkur'
  get 'orchestrions/fool', to: redirect('images/fool.png')
  get 'parasols', to: redirect('images/parasols.png')
  get 'peregrin', to: redirect('images/peregrin.png')

  post 'locale/set', to: 'locale#update'

  post 'shared/filter', to: 'shared#filter'

  resources :search, only: [:index]
  get 'latest', to: redirect('search')

  resources :mounts, only: [:index, :show]

  resources :minions, only: [:index, :show] do
    get :verminion, on: :collection
  end

  resources :orchestrions, only: [] do
    get :select, on: :collection
  end

  resources :spells, only: [] do
    get :battle, on: :collection
  end

  %i(orchestrions emotes bardings hairstyles armoires spells fashions frames records survey_records).each do |resource|
    resources resource, only: [:index, :show] do
      post :add, :remove, on: :member
    end
  end

  resources :leves, only: [] do
    collection do
      get :battlecraft
      get :tradecraft
      get :fieldcraft
    end

    post :add, :remove, on: :member
  end

  scope :triad, module: :triad do
    resources :cards, only: [:index, :show] do
      member do
        post 'add'
        post 'remove'
      end

      collection do
        get 'select'
        post 'set'
      end
    end

    get 'cards/no/:id', to: 'cards#no'
    get 'cards/ex/:id', to: 'cards#ex'

    resources :npcs, only: [:index, :show] do
      member do
        post 'add'
        post 'remove'
      end

      post 'defeated/update', on: :collection, to: 'npcs#update_defeated', as: :update_defeated
    end

    resources :decks do
      get 'mine', as: :my, on: :collection
      post 'upvote'
      post 'downvote'
    end

    resources :packs, only: [:index]
  end

  # TODO: Delete these routes after shutting down ATTT
  namespace :triad do
    resource :import, only: [] do
      collection do
        get :index
        post :execute
      end
    end
  end

  namespace :relics, as: :relic do
    get :weapons
    get :armor
    get :tools
    get :garo
  end

  resources :relics, as: :relic, only: [] do
    post :add, :remove, on: :member
  end

  resources :tools, only: [] do
    collection do
      get :gemstones, :market_board, :materiel, :treasure
    end
  end

  # Backwards compatibility for old relics URLs
  get 'relics', to: redirect('relics/weapons')
  get 'relics/gear', to: redirect('relics/armor')
  get 'relics/weapons/manual', to: redirect('relics/weapons')

  resources :tomestones, only: [:index, :show]

  get 'yokai', to: 'yokai#index'

  get 'achievements/types', to: redirect('404')
  get 'achievements/types/:id', to: 'achievements#type', as: :achievement_type
  get 'achievements/items', to: 'achievements#items', as: :achievement_items
  get 'achievements/search', to: 'achievements#search', as: :achievement_search
  resources :achievements, only: [:index, :show]

  resources :characters, only: [:show, :destroy] do
    member do
      get 'stats/recent', to: 'characters#stats_recent', as: :stats_recent
      get 'stats/rarity', to: 'characters#stats_rarity', as: :stats_rarity
      get :verify
      post :view, :select, :compare, :validate
    end

    collection do
      get :search, :profile
      get 'search/lodestone', to: 'characters#search_lodestone'
      post 'search/lodestone_id', to: 'characters#search_lodestone_id', as: :search_lodestone_id
    end
  end

  resources :free_companies, only: [:show], path: :fc do
    get :collections, :mounts, :spells
    post :refresh, on: :member
  end

  resources :groups do
    get :collections, :mounts, :spells

    member do
      get :manage
      post :refresh
      post :character_search
      post 'add/:character_id', action: :add_character, as: :add_character
      post 'remove/:character_id', action: :remove_character, as: :remove_character
    end
  end

  resources :titles, only: :index

  resources :leaderboards, only: :index do
    collection do
      get 'fc/:id', as: :free_company, action: :free_company
      get 'group/:id', as: :group, action: :group
    end
  end

  get 'commands', to: 'static#commands'
  get 'faq', to: 'static#faq'
  get 'credits', to: 'static#credits'

  get   'settings',           to: 'settings#edit'
  patch 'settings/user',      to: 'settings#update_user',      as: :user_settings
  patch 'settings/character', to: 'settings#update_character', as: :character_settings
  get   'settings/user',      to: redirect('settings')
  get   'settings/character', to: redirect('settings')

  post 'character/refresh',   to: 'characters#refresh',  as: :refresh_character
  delete 'character/forget',  to: 'characters#forget',   as: :forget_character
  delete 'character/comparison/forget', to: 'characters#forget_comparison', as: :forget_character_comparison

  namespace :api do
    resources :characters, only: :show do
      get ':collection/owned', action: :owned, as: :owned
      get ':collection/missing', action: :missing, as: :missing
    end

    resources :users, only: :show do
      get ':collection/owned', action: :owned, as: :owned
      get ':collection/missing', action: :missing, as: :missing
    end

    %i(achievements titles mounts minions orchestrions emotes bardings hairstyles armoires spells fashions frames
    records survey_records relics leves tomestones).each do |resource|
      resources resource, only: [:index, :show]
    end

    namespace :triad do
      %i(cards decks npcs packs).each do |resource|
        resources resource, only: [:index, :show]
      end
    end
  end

  get 'api/docs', to: redirect('https://documenter.getpostman.com/view/1779678/TzXzDHM1')

  post 'discord/interactions'

  namespace :admin do
    resources :users, :groups, only: :index

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
    %i(mounts minions orchestrions emotes bardings hairstyles armoires spells fashions frames cards records survey_records).each do |resource|
      resources resource, only: [:index, :edit, :update]
    end

    resources :sources, only: :destroy
    get 'dashboard', action: :index
  end

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
