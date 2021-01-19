namespace :open_gov do
  resources :articles, only: [:index, :show]
end