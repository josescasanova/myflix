class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: staging_or_user_email, from: "info@app23722853.mailgun.org", subject: "Welcome to Myflix!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: staging_or_user_email, from: "info@app23722853.mailgun.org", subject: "Please reset your password"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: staging_or_invitation_email, from: "info@app23722853.mailgun.org", subject: "Invitation to MyFlix"
  end

  private

  def staging_or_user_email
     Rails.env.staging? ? "josescasanova+staging@gmail.com" : "#{user.email}"
  end

  def staging_or_invitation_email
    Rails.env.staging? ? "josescasanova+staging@gmail.com" : "#{invitation.recipient_email}"
  end
end