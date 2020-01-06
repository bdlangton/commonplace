# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, defaults: { format: :html },
             path: "",
             path_names: { sign_up: "register" },
             controllers: {
               sessions: "sessions",
               registrations: "registrations"
             }

  devise_scope :user do
    get "users/sign_in", to: "devise/sessions#new"
    get "users/register", to: "devise/registrations#new"
    post "users/register", to: "devise/registrations#create"
    delete "users/sign_out", to: "devise/sessions#destroy"
  end

  # API namespace, for JSON requests at /api/v1/sign_[in|out]
  namespace :api, constraints: { format: "json" } do
    namespace :v1, constraints: { format: "json" } do
      devise_for :users,
        defaults: { format: :json },
        class_name: "ApiUser",
        skip: [:registrations, :invitations,
          :passwords, :confirmations,
          :unlocks],
        path: "",
        path_names: {
          sign_in: "login",
          sign_out: "logout"
        }

      devise_scope :user do
        get "login", to: "/devise/sessions#new"
        delete "logout", to: "/devise/sessions#destroy"
      end
    end
  end

  # Deleted/unpublished routes.
  get "highlights/:id/publish", to: "highlights#publish"
  get "highlights/:id/unpublish", to: "highlights#unpublish"
  get "highlights/deleted", to: "highlights#deleted"

  # Favorites routes.
  get "highlights/:id/favorite", to: "highlights#favorite"
  get "highlights/:id/unfavorite", to: "highlights#unfavorite"
  get "favorites", to: "highlights#favorites"

  # Search.
  get "highlights/search", to: "highlights#search"

  # Tags.
  get "tags/merge", to: "tags#merge"
  post "tags/merge", to: "tags#merge_post"

  # Autocomplete.
  resources :tags do
    get :autocomplete_tags_title, on: :collection
  end
  resources :sources do
    get :autocomplete_authors_name, on: :collection
  end

  # Resources.
  resources :authors
  resources :highlights
  resources :sources
  resources :tags

  # User settings.
  get "settings", to: "users#settings"
  patch "user/:id", to: "users#update", as: :user

  # Import.
  get "import", to: "import#form"
  post "import", to: "import#import"
  post "upload", to: "import#upload"

  # Root page.
  root "highlights#index"
end
