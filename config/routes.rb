Rails.application.routes.draw do
  get 'welcome/index'
  get 'import/import'

  resources :highlights
  resources :sources
  resources :tags, except: :show

  get 'highlights/:id/favorite', to: 'highlights#favorite'
  get 'highlights/:id/unfavorite', to: 'highlights#unfavorite'

  get 'tags/:tag', to: 'highlights#index', as: "tag"

  root 'welcome#index'
end
