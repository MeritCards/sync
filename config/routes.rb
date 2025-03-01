Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "application#index"

  scope format: false do
    get "login" => "sessions#new"
    post "login" => "sessions#create"
    delete "logout" => "sessions#destroy"

    scope "my" do
      get "" => "users#show", as: "user"
      get "edit" => "users#edit", as: "edit"
      put "" => "users#update"

      get "delete/confirmation" => "users#delete_confirmation", as: "delete_confirmation"
      delete "" => "users#destroy"

      resources :archives, path: "archives", only: [ :index, :create, :new, :show, :destroy ] do
        put "promote"

        member do
          get "download", to: "archives#download"
        end

        collection do
          get "latest"
          get "latest/download", to: "archives#download"
        end
      end
    end
  end
end
