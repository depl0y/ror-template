class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			remember_token = User.new_remember_token

			if params[:rememberme]
				cookies.permanent[:remember_token] = remember_token
			else
				cookies[:remember_token] = remember_token
			end

			user.update_attribute(:remember_token, User.encrypt(remember_token))
			self.current_user = user

			respond_to do |format|
				format.html { redirect_back_or profile_path }
				format.json { render :json => {:status => "ok", :token => remember_token} }
			end
		else
			respond_to do |format|
				format.html {
					flash.now[:error] = "E-mail adres/wachtwoord combinatie niet gevonden"
					render 'new'
				}
				format.json { render :json => {:status => "error"} }
			end
		end
	end

	def destroy
		sign_out
		redirect_to root_url
	end

end
