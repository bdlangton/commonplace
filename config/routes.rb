Rails.application.routes.draw do
  devise_for :users

  # Resources.
  resources :highlights, except: :show
  resources :sources
  resources :tags

  # Deleted/unpublished routes.
  get 'highlights/:id/publish', to: 'highlights#publish'
  get 'highlights/:id/unpublish', to: 'highlights#unpublish'
  get 'highlights/deleted', to: 'highlights#deleted'

  # Favorites routes.
  get 'highlights/:id/favorite', to: 'highlights#favorite'
  get 'highlights/:id/unfavorite', to: 'highlights#unfavorite'
  get 'favorites', to: 'highlights#favorites'

  # Import.
  get 'import', to: 'import#form'
  post 'import', to: 'import#import'

  # Root page.
  root 'highlights#index'
end
