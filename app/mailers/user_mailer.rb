class UserMailer < ActionMailer::Base
  default from: "noreply@bleapp.net"

  def notifier_email(user)
    @user = user
    mail(to: "register@bleapp.net", subject: 'New agent registration')
  end
end