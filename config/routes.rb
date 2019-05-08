Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  post 'locale/set', to: 'locale#update'

  %i(mounts minions orchestrions hairstyles).each do |resource|
    resources resource, only: [:index, :show]
  end

  %i(emotes bardings armoires).each do |resource|
    resources resource, only: :index
  end

  resources :achievements, only: [:index, :show]
  get 'achievements/types/:id', to: 'achievements#type', as: :achievement_type

  get '404', to: 'home#not_found', as: :not_found
  match "api/*path", via: :all, to: -> (_) { [404, { 'Content-Type' => 'application/json' },
                                              ['{"status": 404, "error": "Not found"}'] ] }
  match "*path", via: :all, to: redirect('404')

  root 'home#index'
end
