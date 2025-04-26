class User < ApplicationRecord
  has_secure_password
  after_create :assign_pending_invitations

  has_many :project_members, dependent: :destroy
  has_many :projects, through: :project_members

  # email のバリデーション
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

  private

  # 招待があれば自動で project_members に登録
  def assign_pending_invitations
    Invitation.where(email: self.email).find_each do |invitation|
      ProjectMember.create!(
        project_id: invitation.project_id,
        user_id: self.id,
        owner: 0
      )
      invitation.destroy  # 招待済みのため削除
    end
  end
end
