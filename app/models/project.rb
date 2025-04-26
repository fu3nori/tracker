class Project < ApplicationRecord
  belongs_to :user  # オーナー（作成者）

  has_many :project_members, dependent: :destroy
  has_many :users, through: :project_members  # 参加ユーザー

  validates :project_name, :description, presence: true
end
