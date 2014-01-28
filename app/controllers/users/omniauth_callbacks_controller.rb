class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      #sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      sign_in(@user)
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      
	  self.current_user = @user
      
      redirect_to profile_path
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      
      if !@current_user.nil?
      	redirect_to profile_path
      else
      	redirect_to signup_path
      end
    end
  end
end