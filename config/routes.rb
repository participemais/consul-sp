Rails.application.routes.draw do
  namespace :dynamic_selectable do
    get 'geozones/:geozone_id/districts', to: 'sub_districts#index', as: :sub_districts
  end

  mount Ckeditor::Engine => "/ckeditor"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  draw :account
  draw :admin
  draw :annotation
  draw :budget
  draw :comment
  draw :community
  draw :debate
  draw :devise
  draw :edition
  draw :direct_upload
  draw :document
  draw :graphql
  draw :legislation
  draw :management
  draw :moderation
  draw :notification
  draw :officing
  draw :open_gov
  draw :poll
  draw :proposal
  draw :related_content
  draw :tag
  draw :user
  draw :valuation
  draw :verification

  root "welcome#index"
  get "/welcome", to: "welcome#welcome"
  get "/consul.json", to: "installation#details"

  resources :stats, only: [:index]
  resources :images, only: [:destroy]
  resources :documents, only: [:destroy]
  resources :follows, only: [:create, :destroy]
  resources :remote_translations, only: [:create]

  # More info pages
  get "help", to: "pages#show", id: "help/index", as: "help"
  get "help/how-to-use",
    to: "pages#show",
    id: "help/how_to_use/index",
    as: "how_to_use"
  get "help/faq", to: "pages#show", id: "faq", as: "faq"
  get "audiencias", to: "pages#show", id: "audiencias", as: "audiencias"
  # Static pages
  resources :pages, path: "/", only: [:show]
end
