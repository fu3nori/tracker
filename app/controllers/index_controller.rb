class IndexController < ApplicationController
  def index
  end

  def legal
  end

  def usage
  end
  def login
    @user = User.new
  end

  def login_post
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password])
      session[:user_id] = user.id
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



  def user_params
    params.require(:user).permit(:email, :pen_name, :zip_code, :addres, :real_name, :bank, :password, :password_confirmation)
  end

  def dashboard
  end

  def lost_password
  end

  def send_reset_token
    Rails.logger.debug "[send_reset_token] called with #{params.inspect}"

    user = User.find_by(email: params[:email])
    if user
      token = rand.to_s[2..7]
      user.update(one_time_token: token)

      UserMailer.with(user: user, token: token).send_token.deliver_now
      redirect_to reset_password_path, notice: "ワンタイムパスワードを送信しました。"
    else
      flash.now[:alert] = "そのメールアドレスは登録されていません。"
      render :lost_password, status: :unprocessable_entity
    end
  end

  def reset_password
  end

  def update_password
    user = User.find_by(email: params[:email], one_time_token: params[:token])
    if user
      if params[:password] == params[:password_confirmation]
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]
        user.one_time_token = nil
        if user.save
          redirect_to login_path, notice: "パスワードを更新しました。ログインしてください。"
        else
          flash.now[:alert] = "パスワードの更新に失敗しました。"
          render :reset_password, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "パスワードが一致しません。"
        render :reset_password, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "メールアドレスかトークンが無効です。"
      render :reset_password, status: :unprocessable_entity
    end
  end


  def admin_set
  end

  def logout
  end

end
# rails generate controller index legal usage login signup dashboard reset_password --skip-routes --skip-controller --skip-assets --skip-helper