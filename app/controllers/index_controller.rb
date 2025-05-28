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
    Rails.logger.debug "[login_post] params[:user] = #{params[:user].inspect}"
    begin
      user_params = params.require(:user).permit(:email, :password)
      user_email = user_params[:email].strip.downcase
      Rails.logger.debug "全パラメータ: #{params.inspect}"
      Rails.logger.debug "params[:user]: #{params[:user].inspect}"
      Rails.logger.debug "params[:user].class: #{params[:user].class}"

    rescue => e
      Rails.logger.error "[login_post] パラメータ構文エラー: #{e.class} - #{e.message}"
      Rails.logger.error (e.backtrace&.join("\n") || "No backtrace available")
      flash.now[:alert] = "ログインフォームに問題があります。"
      @user = User.new
      render :login, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: user_email)

    if user&.authenticate(user_params[:password])
      session[:user_id] = user.id

      Invitation.where(email: user.email).find_each do |invitation|
        begin
          pm = ProjectMember.find_or_initialize_by(
            project_id: invitation.project_id,
            user_id: user.id
          )
          pm.owner ||= 0  # ← enum の整数値で代入（:member = 0）
          pm.save!

          invitation.destroy!
        rescue => e
          Rails.logger.error "[login_post] ProjectMember 作成エラー: #{e.class} - #{e.message}"
          Rails.logger.error (e.backtrace&.join("\n") || "No backtrace available")
          next
        end
      end

      redirect_to dashboard_path
    else
      flash.now[:alert] = "メールアドレスかパスワードが間違っています。"
      @user = User.new(email: user_email)
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
