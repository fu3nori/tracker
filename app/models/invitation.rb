class Invitation < ApplicationRecord
  belongs_to :project

  validates :email, presence: true
  validates :project_id, presence: true
end

