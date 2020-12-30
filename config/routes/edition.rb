namespace :edition do
  root to: "dashboard#index"

  scope module: :poll do
    resources :polls do
      get :booth_assignments, on: :collection
      patch :add_question, on: :member

      resources :editors, only: [:index, :create, :destroy] do
        get :search, on: :collection
      end

      resources :booth_assignments, only: [:index, :show, :create, :destroy] do
        get :search_booths, on: :collection
        get :manage, on: :collection
      end

      resources :officer_assignments, only: [:index, :create, :destroy] do
        get :search_officers, on: :collection
        get :by_officer, on: :collection
      end

      resources :recounts, only: :index
      resources :results, only: :index

      resources :electoral_colleges, except: [:show] do
        resources :electors, only: [:new, :create, :edit, :update, :destroy], controller: "electoral_colleges/electors" do
          get :search_electors, on: :collection
        end
        namespace :electors do
          resources :imports, only: [:new, :create, :show]
        end
      end

    end

    resources :questions, shallow: true do
      resources :answers, except: [:index, :destroy], controller: "questions/answers" do
        resources :images, controller: "questions/answers/images"
        resources :videos, controller: "questions/answers/videos"
        get :documents, to: "questions/answers#documents"
      end
      post "/answers/order_answers", to: "questions/answers#order_answers"
    end

    resource :active_polls, only: [:create, :edit, :update]
  end

  namespace :legislation do
    resources :processes, except: [:new, :create, :destroy] do
      resources :questions
      resources :proposals do
        member { patch :toggle_selection }
      end
      resources :draft_versions
      resources :milestones
      resources :progress_bars, except: :show
      resource :homepage, only: [:edit, :update]
      resources :topics, except: [:show] do
        get :document, on: :collection
      end
      resources :topic_levels, except: [:index, :show]
    end
  end

  resources :milestone_statuses, only: [:index, :new, :create, :update, :edit, :destroy]
end