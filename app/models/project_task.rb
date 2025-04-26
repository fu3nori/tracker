# app/models/project_task.rb
class ProjectTask < ApplicationRecord
  belongs_to :project
  belongs_to :project_member

  validates :task_name, presence: true
  validates :task_status, inclusion: { in: [0, 1, 2] }
  validates :task_description, presence: true
end
