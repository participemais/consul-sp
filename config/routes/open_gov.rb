namespace :open_gov do
   resources :articles, only: [:index, :show]
   resources :participation_articles, only: [:index, :show]
   resources :projects, only: [:index, :show]
end