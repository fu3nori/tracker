# app/controllers/index_controller.rb
class IndexController < ApplicationController
  # ダッシュボードだけログイン必須
  before_action :load_current_user, only: [:dashboard]
  before_action :require_login, only: [:dashboard]

  # ← public アクション群 start ↓

  def index
  end

  def legal
  end

  def usage
  end

  def login
    if session[:user_id] && User.exists?(id: session[:user_id])
      redirect_to dashboard_path
    else
      @user = User.new
    end
  end


  def login_post
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password])
      session[:user_id] = user.id
      Invitation.where(email: user.email).find_each do |invitation|
        unless ProjectMember.exists?(project_id: invitation.project_id, user_id: user.id)
          ProjectMember.create!(
            project_id: invitation.project_id,
            user_id: user.id,
            owner: 0
          )
        end
        invitation.destroy
      end
      redirect_to dashboard_path
    else
      flash.now[:alert] = "メールアドレスかパスワードが間違っています。"
      @user = User.new(email: params[:user][:email])
      render :login, status: :unprocessable_entity
    end
  end

  def signup
    @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "登録が完了しました。ログインしてください。"
    else
      flash.now[:alert] = "入力内容に不備があります。"
      render :signup, status: :unprocessable_entity
    end
  end

  def dashboard
    @project_memberships = ProjectMember.where(user_id: @current_user.id)
    @projects = @project_memberships.map { |pm| pm.project }
  end

  def lost_password
  end

  def send_reset_token
    # 省略…
  end

  def reset_password
  end

  def update_password
    # 省略…
  end

  def admin_set
  end

  def logout
    reset_session
    redirect_to login_path, notice: "ログアウトしました。"
  end

  # ← public アクション群 end ↑

  private

  def load_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_login
    return if @current_user
    render file: Rails.root.join("public", "403.html"),
           status: :forbidden,
           layout: false
  end

  def user_params
    params.require(:user)
          .permit(:email, :pen_name, :zip_code, :addres,
                  :real_name, :bank, :password,
                  :password_confirmation)
  end
end
