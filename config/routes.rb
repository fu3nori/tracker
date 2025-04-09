Rails.application.routes.draw do
  get "index/index"
  # サブディレクトリ'/tracker'以下のルーティングを定義する
  scope '/tracker' do
    # /tracker でトップページとして index#index を表示する
    root 'index#index'

    # ここに /tracker 配下のその他のルートを記述（例：resources :posts など）
  end

  # アプリのヘルスチェック用エンドポイント。/up にアクセスすると、
  # アプリが例外なく起動していれば200を返す仕組み。
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA関連のルーティング（必要に応じてコメントアウトを外す）
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # ルートパス（"/"）の設定はここでは不要。/tracker がトップとなる
  # root "posts#index"  ←不要なためコメントアウト
end
