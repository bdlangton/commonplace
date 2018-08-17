Rails.application.routes.draw do
  get 'welcome/index'
  get 'import/import'

  resources :highlights
  resources :sources
  resources :tags

  root 'welcome#index'
end
