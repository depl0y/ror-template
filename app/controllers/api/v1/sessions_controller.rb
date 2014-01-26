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
			sign_in(user)
	
			respond_to do |format|
				format.json { render :json => { :status => "ok", :token => remember_token } }
			end
		else
			respond_to do |format|
				format.json { render :json => { :status => "error" } }
			end
		end
	end
	
	def logout
		sign_out
		
		respond_to do |format|
			format.json { render :json => { :status => "ok" } }
		end
		
	end
  
end
