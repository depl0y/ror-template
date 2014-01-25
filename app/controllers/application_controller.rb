class ApplicationController < ActionController::Base
  include SessionsHelper  
  protect_from_forgery with: :exception
  
  before_action :get_contact_messages
  
  private
  
  	def get_contact_messages
  	
  		if cookies[:contact_last] && signed_in? &&  admin_user?
  			@date = Time.at(cookies[:contact_last].to_i)
	  		@contact_count = ContactMessage.where("created_at >= ?", @date).count
	  		@reminder_count = RemindersController.get_reminders.count
	  	end
	  	  	
  	end
  
/#
  before_filter :check_invite, except: [:waiting]
#/	
#  before_filter :configure_permitted_parameters if :devise_controller?
/#
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :accountNumber, :password, :password_confirmation)
    end
    
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :accountNumber, :password, :password_confirmation)
    end  	
 end
#/

end
