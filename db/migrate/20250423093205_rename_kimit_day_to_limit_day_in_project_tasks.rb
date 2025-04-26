class RenameKimitDayToLimitDayInProjectTasks < ActiveRecord::Migration[6.1]
  def change
    rename_column :project_tasks, :kimit_day, :limit_day
  end
end
