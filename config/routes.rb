Rails.application.routes.draw do
  get 'welcome/index'
  get 'import/import'

  resources :highlights, except: :show
  resources :sources
  resources :tags

  get 'highlights/:id/favorite', to: 'highlights#favorite'
  get 'highlights/:id/unfavorite', to: 'highlights#unfavorite'

  root 'welcome#index'
end
