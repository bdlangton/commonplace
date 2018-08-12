Rails.application.routes.draw do
  get 'welcome/index'

  resources :highlights

  root 'welcome#index'
end
