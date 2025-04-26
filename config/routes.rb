Rails.application.routes.draw do
  get "index/index"

  scope '/tracker' do
    root 'index#index', as: :tracker
    get '/', to: 'index#index'
    get 'legal', to: 'index#legal', as: :legal
    get 'usage', to: 'index#usage', as: :usage
    get 'login', to: 'index#login', as: :login
    post 'login', to: 'index#login_post'
    get 'dashboard', to: 'index#dashboard', as: :dashboard
    get 'signup', to: 'index#signup'
    post 'signup', to: 'index#create_user', as: :create_user
    get 'admin_set', to: 'index#admin_set', as: :admin_set
    get 'logout', to: 'index#logout', as: :logout
    get 'lost_password', to: 'index#lost_password', as: :lost_password
    post 'lost_password', to: 'index#send_reset_token'
    get 'reset_password', to: 'index#reset_password', as: :reset_password
    post 'reset_password', to: 'index#update_password'

    get  'projects/new', to: 'projects#new', as: :new_project
    post 'projects',     to: 'projects#create', as: :projects

    resources :projects, only: [:new, :create, :show] do
      member do
        get 'invite'
        post 'invite', to: 'projects#send_invite'
        get 'edit'
        patch '/', to: 'projects#update', as: :update
      end

      resources :project_tasks, only: [:new, :create, :edit, :update, :destroy] do
        post 'force_destroy', on: :member  # ← ★ OK これで間違いない！
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
