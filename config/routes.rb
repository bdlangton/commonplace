Rails.application.routes.draw do
  get 'welcome/index'

  resources :highlights
  resources :sources
  resources :tags

  root 'welcome#index'
end
