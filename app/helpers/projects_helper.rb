module ProjectsHelper
  def owner?(user, project)
    Rails.logger.debug "Checking ownership: user=#{user.id}, project=#{project.id}"
    exists = ProjectMember.exists?(project_id: project.id, user_id: user.id, owner: 1)
    Rails.logger.debug "Ownership result: #{exists}"
    exists
  end
end


