namespace :admin do
  root to: "dashboard#index"
  resources :organizations, only: :index do
    get :search, on: :collection
    member do
      put :verify
      put :reject
    end
  end

  resources :hidden_users, only: [:index, :show] do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :hidden_budget_investments, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :hidden_debates, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :debates, only: [:index, :show]

  resources :proposals, only: [:index, :show, :update] do
    member { patch :toggle_selection }
    resources :milestones, controller: "proposal_milestones"
    resources :progress_bars, except: :show, controller: "proposal_progress_bars"
  end

  resources :hidden_proposals, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :proposal_notifications, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :budgets do
    member do
      put :calculate_winners
    end

    resources :groups, except: [:show], controller: "budget_groups" do
      resources :imports, only: [:new, :create, :show], controller: "budget_group_imports"
      resources :headings, except: [:new, :create, :show, :destroy], controller: "budget_headings"
    end

    resources :budget_investments, only: [:index, :show, :edit, :update] do
      member { patch :toggle_selection }

      resources :audits, only: :show, controller: "budget_investment_audits"
      resources :milestones, controller: "budget_investment_milestones"
      resources :progress_bars, except: :show, controller: "budget_investment_progress_bars"
    end

    resources :budget_phases, only: [:edit, :update]
  end

  resources :milestone_statuses, only: [:index, :new, :create, :update, :edit, :destroy]

  resources :feasibility_analysis_departments, except: [:show] do
    member { patch :toggle_active }
  end

  resources :signature_sheets, only: [:index, :new, :create, :show]

  resources :banners, only: [:index, :new, :create, :edit, :update, :destroy] do
    collection { get :search }
  end

  resources :hidden_comments, only: :index do
    member do
      put :restore
      put :confirm_hide
    end
  end

  resources :comments, only: :index

  resources :tags

  resources :officials, only: [:index, :edit, :update, :destroy] do
    get :search, on: :collection
  end

  resources :settings, only: [:index, :update]
  put :update_map, to: "settings#update_map"
  put :update_content_types, to: "settings#update_content_types"

  resources :moderators, only: [:index, :create, :destroy] do
    get :search, on: :collection
  end

  resources :valuators, only: [:show, :index, :edit, :update, :create, :destroy] do
    get :search, on: :collection
    get :summary, on: :collection
  end

  resources :valuator_groups

  resources :managers, only: [:index, :create, :destroy] do
    get :search, on: :collection
  end

  resources :administrators, only: [:index, :create, :destroy, :edit, :update] do
    get :search, on: :collection
  end

  resources :editors, only: [:index, :create, :destroy] do
    get :search, on: :collection
  end

  resources :users, only: [:index, :show]

  scope module: :poll do
    resources :officers, only: [:index, :new, :create, :destroy] do
      get :search, on: :collection
    end

    resources :booths do
      get :available, on: :collection

      resources :shifts do
        get :search_officers, on: :collection
      end
    end

    resource :active_polls, only: [:create, :edit, :update]
  end

  resources :verifications, controller: :verifications, only: :index do
    get :search, on: :collection
  end

  resource :activity, controller: :activity, only: :show

  resources :newsletters do
    member do
      post :deliver
    end
    get :users, on: :collection
  end

  resources :admin_notifications do
    member do
      post :deliver
    end
  end

  resources :system_emails, only: [:index] do
    get :view
    get :preview_pending
    put :moderate_pending
    put :send_pending
  end

  resources :emails_download, only: :index do
    get :generate_csv, on: :collection
  end

  resource :stats, only: :show do
    get :graph, on: :member
    get :budgets, on: :collection
    get :budget_supporting, on: :member
    get :budget_balloting, on: :member
    get :proposal_notifications, on: :collection
    get :direct_messages, on: :collection
    get :polls, on: :collection
  end

  namespace :legislation do
    resources :processes do
      resources :editors, only: [:index, :create, :destroy] do
        get :search, on: :collection
      end
    end
  end

  namespace :api do
    resource :stats, only: :show
  end

  resources :geozones, only: [:index, :new, :create, :edit, :update, :destroy]

  namespace :site_customization do
    resources :pages, except: [:show] do
      resources :cards, only: [:index]
    end
    resources :images, only: [:index, :update, :destroy]
    resources :content_blocks, except: [:show]
    delete "/heading_content_blocks/:id", to: "content_blocks#delete_heading_content_block", as: "delete_heading_content_block"
    get "/edit_heading_content_blocks/:id", to: "content_blocks#edit_heading_content_block", as: "edit_heading_content_block"
    put "/update_heading_content_blocks/:id", to: "content_blocks#update_heading_content_block", as: "update_heading_content_block"
    resources :information_texts, only: [:index] do
      post :update, on: :collection
    end
    resources :documents, only: [:index, :new, :create, :destroy]
  end

  resource :homepage, controller: :homepage, only: [:show]

  namespace :widget do
    resources :cards
    resources :feeds, only: [:update]
  end

  namespace :dashboard do
    resources :actions, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :administrator_tasks, only: [:index, :edit, :update]
  end

  resources :local_census_records
  namespace :local_census_records do
    resources :imports, only: [:new, :create, :show]
  end

  namespace :open_gov do
    resources :articles
    resources :participation_articles
    resources :projects
    resources :plans do
      resources :progress_bars, except: :show
      resources :commitments, except: [:index] do
        resources :marks, except: [:index, :show] do
          resources :lines, except: [:index, :show]
        end
      end
    end
  end
end
