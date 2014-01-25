class PasswordResetsController < ApplicationController
						 
def create
	user = User.find_by_email(params[:email])
	user.send_password_reset if user
  flash[:notice] = { title: "Wachtwoord vergeten", text: "U ontvangt spoedig van ons een e-mail met daarin de instructies om uw wachtwoord te veranderen." }
	redirect_to root_url
end

def edit
	@user = User.find_by_password_reset_token!(params[:id])

  if @user.password_reset_at < 2.hours.ago
    flash[:notice] = { title: "Verlopen", text: "U heeft te lang gewacht met het aanpassen van uw wachtwoord, vraag het wachtwoord opnieuw aan" }
    redirect_to new_password_reset_path
  end
end

def update
	@user = User.find_by_password_reset_token!(params[:id])
	
	@user.password_reset_token = nil
	
	if @user.password_reset_at < 2.hours.ago
		flash[:notice] = { title: "Verlopen", text: "U heeft te lang gewacht met het aanpassen van uw wachtwoord, vraag het wachtwoord opnieuw aan" }
    redirect_to new_password_reset_path
	elsif @user.update_attributes(params[:user].permit(:new_password, :new_password_confirmation))
		flash[:notice] = { title: "Wachtwoord aangepast", text: "Uw wachtwoord is aangepast" }
    	redirect_to login_path
   	else
    	render :edit
  end	
end	

private

    def password_reset_params
      params.require(:password_reset).permit(:email, :new_password, :new_password_confirmation)
    end

end
