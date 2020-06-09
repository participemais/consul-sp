resource :account, controller: "account", only: [:show, :edit, :update, :delete] do
  get :erase, on: :collection
end
