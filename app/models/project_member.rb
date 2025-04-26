class ProjectMember < ApplicationRecord
  belongs_to :user
  belongs_to :project
  has_many :project_tasks

  # 0 = メンバー, 1 = オーナー
  enum :owner, { member: 0, owner: 1 }, suffix: true

  validates :project_id, :user_id, presence: true
  def pen_name_display
    "#{user.pen_name} (#{owner == 'owner' ? 'オーナー' : 'メンバー'})"
  end
end
