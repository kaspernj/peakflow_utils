class MyMailer < ApplicationMailer
  def mailer_action(_user_id)
    mail(subject: t(".custom_subject"))
  end
end
