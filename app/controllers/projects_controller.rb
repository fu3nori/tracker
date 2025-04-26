class ProjectsController < ApplicationController
  before_action :load_current_user
  before_action :require_login

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = @current_user.id
    if @project.save
      ProjectMember.create(project_id: @project.id, user_id: @current_user.id, owner: 1)
      redirect_to dashboard_path, notice: "プロジェクトを作成しました。"
    else
      flash.now[:alert] = "プロジェクトの作成に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @project = Project.find_by(id: params[:id])

    # アクセス権の確認
    unless ProjectMember.exists?(project_id: @project.id, user_id: @current_user.id)
      return render file: Rails.root.join("public", "403.html"), status: :forbidden, layout: false
    end

    # 参加メンバー（user情報含めて）を取得
    @project_members = ProjectMember.includes(:user).where(project_id: @project.id)

    # このプロジェクトに紐づく全タスクを取得（アサインされたメンバー情報も含めて）
    @tasks = ProjectTask.includes(project_member: :user).where(project_id: @project.id)

    # 自分がこのプロジェクトのオーナーかどうかを判定
    current_member = @project_members.find { |m| m.user_id == @current_user.id }
    @is_owner = current_member&.owner == 1
  end

  def show
    @project = Project.find(params[:id])
    unless ProjectMember.exists?(project_id: @project.id, user_id: @current_user.id)
      return render file: Rails.root.join("public", "403.html"), status: :forbidden, layout: false
    end
    @tasks = ProjectTask.includes(:project_member).where(project_id: @project.id)
    @members = ProjectMember.includes(:user).where(project_id: @project.id)

    # ⚠️ ここが重要
    @owner = ProjectMember.exists?(project_id: @project.id, user_id: @current_user.id, owner: 1)
  end

  def edit
    @project = Project.find(params[:id])
    ensure_owner!
  end

  def update
    @project = Project.find(params[:id])
    ensure_owner!

    if @project.update(project_params)
      redirect_to project_path(@project), notice: "プロジェクト情報を更新しました。"
    else
      flash.now[:alert] = "更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  def invite
    @project = Project.find(params[:id])
  end

  def send_invite
    @project = Project.find(params[:id])
    email = params[:email]

    invitation = Invitation.new(email: email, project_id: @project.id)
    if invitation.save
      # @current_user, email, @project を渡す
      ProjectMailer.invite_email(@current_user, email, @project).deliver_now

      redirect_to project_path(@project), notice: "#{email} を招待しました。"
    else
      flash.now[:alert] = "招待に失敗しました。"
      render :invite, status: :unprocessable_entity
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

  def project_params
    params.require(:project).permit(:project_name, :description)
  end

  def ensure_owner!
    member = ProjectMember.find_by(project_id: @project.id, user_id: @current_user.id)
    unless member&.owner?
      render file: Rails.root.join("public", "403.html"), status: :forbidden, layout: false
    end
  end
end
