Rails.application.routes.draw do
  devise_for :users

  # Web Sessions
  get "/sign_in", to: "sessions#new", as: :new_session
  post "/sign_in", to: "sessions#create"
  match "/sign_out", to: "sessions#destroy", via: [:get, :delete]

  # Doctor auth
  get "/doctor_sign_in", to: "sessions#new"
  post "/doctor_sign_in", to: "sessions#create"
  match "/doctor_sign_out", to: "sessions#destroy", via: [:get, :delete]

  # Patient auth
  get "/patient_sign_in", to: "sessions#new"
  post "/patient_sign_in", to: "sessions#create"
  match "/patient_sign_out", to: "sessions#destroy_patient", via: [:get, :delete]

  # Dashboards
  get "patient_dashboard/:id", to: "patients#dashboard", as: :patient_dashboard
  get "doctor_dashboard/:id", to: "doctors#dashboard", as: :doctor_dashboard
  get "doctor_patients", to: "doctors#patients"

  resources :prescriptions, only: [:create, :destroy, :edit, :update]

  root "hospitals#index"

  authenticated :user do
    root "hospitals#index", as: :authenticated_root
  end

  unauthenticated do
    root "sessions#new", as: :unauthenticated_root
  end

  resources :hospitals do
    resource :profile

    member do
      patch :upload_image
      delete :remove_image
    end

    resources :doctors
    resources :patients
    resources :appointments do
      patch :update_status, on: :member
    end
  end

  # API (clean single block)
 namespace :api do
  post "login", to: "sessions#create"
  post "hospital_login", to: "sessions#hospital_login"
  resources :doctors, only: [:index, :show]
  resources :hospitals, only: [:index]
end
end