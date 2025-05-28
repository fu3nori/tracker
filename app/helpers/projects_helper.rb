module ProjectsHelper
  # パターン①: user + project を指定して判定（既存）
  def owner?(user, project)
    Rails.logger.debug "Checking ownership: user=#{user.id}, project=#{project.id}"
    exists = ProjectMember.exists?(project_id: project.id, user_id: user.id, owner: 1)
    Rails.logger.debug "Ownership result: #{exists}"
    exists
  end

  # パターン②: project_member を直接渡す場合（controller用）
  def owner_from_member?(project_member)
    project_member&.owner == 1
  end
end


