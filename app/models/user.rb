class User < ApplicationRecord
  has_secure_password

  # 必須バリデーション
  validates :email, presence: true, uniqueness: true
  validates :pen_name, presence: true
  validates :password, presence: true,
            length: { in: 4..8 },
            format: { with: /\A[\x20-\x7E]*\z/, message: "は半角英数記号のみ使用できます" }
end
