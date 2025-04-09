# Load the Rails application.
require_relative "application"

# ←ここではまだ初期化しない！

# 相対URLルート設定（初期化前に行うこと）
ENV['RAILS_RELATIVE_URL_ROOT'] ||= "/tracker"

# Initialize the Rails application.
Rails.application.initialize!
