require "active_support/core_ext/integer/time"

Rails.application.configure do
  # --- 基本設定 ---
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # --- publicファイルのヘッダ設定 ---
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # --- Active Storage ---
  config.active_storage.service = :local

  # --- SSL強制（Let’s Encrypt経由でHTTPSリバースプロキシ前提）---
  config.assume_ssl = true
  config.force_ssl = true

  # --- ロギング ---
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  # --- キャッシュ & ジョブ ---
  config.cache_store = :memory_store
  config.active_job.queue_adapter = :async

  # --- メール設定（必要なら使ってくれ）---
  config.action_mailer.default_url_options = { host: "hf-avenue.biz" }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: 'apikey',
    password: ENV['SENDGRID_API_KEY'],
    domain: 'hf-avenue.biz',
    address: 'smtp.sendgrid.net',
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

  # --- I18n ---
  config.i18n.fallbacks = true

  # --- DBマイグレーションログ ---
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [:id]

  # === 💡 サブディレクトリ公開設定 ===
  config.relative_url_root = "/tracker"
  config.action_controller.relative_url_root = "/tracker"
  # === 💡 アセットの公開パス変更（/tracker/assets に対応）===
  config.assets.prefix = "/tracker/assets"
end
