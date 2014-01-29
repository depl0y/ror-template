class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])

			sign_in(user)

			respond_to do |format|
				format.html { redirect_back_or profile_path }
				format.json { render :json => {:status => t("api.ok"), :token => remember_token} }
			end
		else
			respond_to do |format|
				format.html {
					flash.now[:error] = "E-mail adres/wachtwoord combinatie niet gevonden"
					render 'new'
				}
				format.json { render :json => {:status => t("api.error") } }
			end
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
