class UserMailer < ApplicationMailer
  default from: 'noreply@hf-avenue.biz'

  def send_token
    @user = params[:user]
    @token = params[:token]
    mail(
      to: @user.email,
      subject: '【HF-AVENUE】パスワード再発行用ワンタイムパスワード'
    )
  end
end

