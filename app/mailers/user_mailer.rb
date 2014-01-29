class UserMailer < ActionMailer::Base
  default from: "noreply@App.nl"
  
  def welcome_email(user)
  	@user = user
  	@url = Rails.application.config.site_url
  	
  	mail(to: @user.email, subject: t("user_mailer.subjects.welcome_email", sitename: t("sitename")))
  end
  
  def welcome_email_provider(user)
  	@user = user
  	@url = Rails.application.config.site_url

	mail(to: @user.email, subject: t("user_mailer.subjects.welcome_email", sitename: t("sitename")))

  end
  
  def password_reset(user)
  	@user = user
  	@url = Rails.application.config.site_url
  	
  	mail :to => @user.email, :subject => t("user_mailer.subjects.password_reset", sitename: t("sitename"))
  end
  
  def contact_message(message)
  	@message = message
  	@url = Rails.application.config.site_url
  	
  	mail :to => Rails.application.config.admin_email, subject: "Contact: " + message.subject, :from => @message.email
  end
  
end
