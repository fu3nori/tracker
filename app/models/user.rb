class User < ApplicationRecord
  has_secure_password

  # 必須バリデーション
  validates :email, presence: true, uniqueness: { message: "は既に登録されています" }
  validates :email, presence: true,
            uniqueness: { case_sensitive: false, message: "は既に登録されています" },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "は正しい形式で入力してください" }
  validates :pen_name, presence: true
  validates :password, presence: true,
            length: { in: 4..8 },
            format: { with: /\A[\x20-\x7E]*\z/, message: "は半角英数記号のみ使用できます" }
end
