# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    collection { post :import }
    member do
      patch 'user_update'
      get 'csv_show'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'index_attendance'
      get 'csv_user_attendance'
    end
    resources :attendances do
      member do
        get 'edit_overtime_application'
        patch 'update_overtime_application'
        get 'edit_superior_overtime_application'
        patch 'update_superior_overtime_application'
        get 'attendance_change_confirmation'
        patch 'update_attendance_change_confirmation'
        patch 'update_month_superior'
        get 'month_approval'
        patch 'update_month_approval'
      end
    end
    resources :bases do
    end
  end
end
