namespace :valuation do
  root to: "budgets#index"

  resources :budgets, only: :index do
    resources :budget_investments, only: [:index, :show, :edit] do
      patch :valuate, on: :member
      resources :feasibility_analyses,
        controller: "budget_investment_feasibility_analyses",
        except: [:index, :show]
    end
  end
end
