Rails.application.routes.draw do
  # Resources.
  resources :highlights, except: :show
  resources :sources
  resources :tags

  # Favorites routes.
  get 'highlights/:id/favorite', to: 'highlights#favorite'
  get 'highlights/:id/unfavorite', to: 'highlights#unfavorite'
  get 'favorites', to: 'highlights#favorites'

  # Import.
  get 'import/import'

  # Root page.
  root 'highlights#index'
end
