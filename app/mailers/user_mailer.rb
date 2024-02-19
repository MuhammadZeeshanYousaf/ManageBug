class UserMailer < ApplicationMailer
  def assigning_email(user)
    mail(to: user, subject: "Assigned to a Project/Bug")
  end
end
