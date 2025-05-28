class ProjectTasksController < ApplicationController
  before_action :load_current_user
  before_action :require_login
  before_action :set_project
  before_action :authorize_project_access!

  def new
    @task = ProjectTask.new
    @members = @project.project_members.includes(:user)
  end

  def create
    @task = ProjectTask.new(task_params)
    @task.project_id = @project.id

    if @task.save
      redirect_to project_path(@project), notice: "タスクを作成しました。"
    else
      @members = @project.project_members.includes(:user)
      flash.now[:alert] = "タスク作成に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = ProjectTask.find(params[:id])
    @members = @project.project_members.includes(:user)
  end

  def update
    @task = ProjectTask.find(params[:id])
    if @task.update(task_params)
      redirect_to project_path(@project), notice: "タスクを更新しました。"
    else
      @members = @project.project_members.includes(:user)
      flash.now[:alert] = "タスク更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  # 🚨 荒技版 destroy
  def force_destroy
    @task = ProjectTask.find(params[:id])
    if @task.destroy
      redirect_to project_path(@project), notice: "タスクを削除しました。"
    else
      redirect_to project_path(@project), alert: "削除に失敗しました。"
    end
  end

  private

  def load_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_login
    return if @current_user
    render file: Rails.root.join("public", "403.html"), status: :forbidden, layout: false
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def authorize_project_access!
    unless ProjectMember.exists?(project_id: @project.id, user_id: @current_user.id)
      render file: Rails.root.join("public", "403.html"), status: :forbidden, layout: false
    end
  end

  def task_params
    params.require(:project_task).permit(:task_name, :task_description, :start_day, :limit_day, :project_member_id, :task_status)
  end
end
