Rails.application.routes.draw do
  get 'welcome/index'
  get 'import/import'

  resources :highlights, except: :show
  resources :sources
  resources :tags

  # Favorites routes.
  get 'highlights/:id/favorite', to: 'highlights#favorite'
  get 'highlights/:id/unfavorite', to: 'highlights#unfavorite'
  get 'favorites', to: 'highlights#favorites'

  root 'welcome#index'
end
