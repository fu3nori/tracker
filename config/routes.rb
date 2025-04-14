Rails.application.routes.draw do
  get "index/index"

  # サブディレクトリ'/tracker'以下のルーティングを定義する
  scope '/tracker' do
    # /tracker でトップページとして index#index を表示する
    root 'index#index', as: :tracker
    get '/', to: 'index#index'
    get 'legal', to: 'index#legal', as: :legal
    get 'usage', to: 'index#usage', as: :usage
    get 'login', to: 'index#login', as: :login
    post 'login', to: 'index#login_post'
    get 'dashboard', to: 'index#dashboard', as: :dashboard
    get 'signup', to: 'index#signup'
    post 'signup', to: 'index#create_user', as: :create_user  # ←これが重要
    get 'admin_set', to: 'index#admin_set', as: :admin_set
    get 'logout', to: 'index#logout', as: :logout
    get 'lost_password', to: 'index#lost_password', as: :lost_password
    post 'lost_password', to: 'index#send_reset_token'
    get 'reset_password', to: 'index#reset_password', as: :reset_password
    post 'reset_password', to: 'index#update_password'

  end

  # アプリのヘルスチェック用エンドポイント
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA関連（必要に応じて）
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # ルートパス（"/"）の設定はここでは不要。/tracker がトップ
  # root "posts#index" ← 不要
end
