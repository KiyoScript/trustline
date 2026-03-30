Rails.application.routes.draw do
  mount RailsIcons::Engine, at: "/rails_icons"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  #

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }, path: "", path_names: {
    sign_in: "sign_in",
    sign_up: "sign_up",
    password: "forgot_password/edit"
  }

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root

    namespace :dashboard do
      resources :pipelines, only: [ :index ]
      resources :leads, only: [ :index, :create ]
      resources :activities, only: [ :index, :create ]
      resources :productivities, only: [ :index ]
    end
  end

  unauthenticated do
    root to: redirect("/sign_in")
  end
end
