class ProjectMailer < ApplicationMailer
  def invite_email(user, email, project)
    @inviter = user
    @project = project
    @email = email

    if User.exists?(email: email)
      @message = "#{email} でログインしてください。"
    else
      @message = "#{email} でアカウントを作ってください。"
    end

    mail(
      from: "noreply@#{ENV['MAIL_DOMAIN'] || 'hf-avenue.biz'}",
      to: email,
      subject: "プロジェクト招待"
    )
  end
end
