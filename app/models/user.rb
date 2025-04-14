class User < ApplicationRecord
  has_secure_password

  # email のバリデーション（まとめた）
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false, message: "は既に登録されています" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "は正しい形式で入力してください" }

  # pen_name 必須
  validates :pen_name, presence: true

  # password バリデーション（create時のみ）
  validates :password,
            presence: true,
            length: { in: 4..8 },
            format: { with: /\A[\x20-\x7E]*\z/, message: "は半角英数記号のみ使用できます" },
            on: :create
end
