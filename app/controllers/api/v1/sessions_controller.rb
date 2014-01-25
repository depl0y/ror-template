class API::V1::SessionsController < ApiController

	def show
		respond_to do |format|
			format.json { render :json => { :status => "ok" } }
		end
	end
	
	def new
	end
	
	def create
		user = User.find_by(email: params[:email].downcase)

		if user && user.authenticate(params[:password])
			remember_token = User.new_remember_token
		
			if params[:rememberme]
				cookies.permanent[:remember_token] = remember_token
			else
				cookies[:remember_token] = remember_token
			end
	
			user.update_attribute(:remember_token, User.encrypt(remember_token))
			self.current_user = user
	
			respond_to do |format|
				format.json { render :json => { :status => "ok", :token => remember_token } }
			end
		else
			format.json { render :json => { :status => "error" } }
		end
	end
	
	def logout
		sign_out
		
		respond_to do |format|
			format.json { render :json => { :status => "ok" } }
		end
		
	end
  
end
