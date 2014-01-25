module SessionsHelper

	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token

		session["devise.facebook_data"] = nil

		@rt = RememberToken.new
		@rt.user_id = user.id
		@rt.token = User.encrypt(remember_token)
		@rt.save

		self.current_user = user
	end
	
	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end
	
	def signed_in?
		!current_user.nil?
	end	
	
	def current_user=(user)
		@current_user = user
	end
	
	def current_user
		remember_token = User.encrypt(cookies[:remember_token])

		@rt = RememberToken.find_by(token: remember_token)

		if @rt.nil?
			@current_user = nil;
		else
			@current_user = @rt.user
		end
	end	
	
	def current_user?(user)
		user == current_user
	end
	
	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end
	
	def valid_password?(password)
  		@authenticated_user = User.find_by(email: current_user.email)
  		return current_user?(@authenticated_user) && @authenticated_user.authenticate(password)
	end
	
	def signed_in_api_user
		unless signed_in?
			respond_to do |format|
				format.json { render :json => { :status => "error", :message => "You are not logged in" } }
			end
			return
		end
	end
	
	def signed_in_user
		unless signed_in?
			store_location
			flash[:notice] = {title: "Sign in required", text: "You need to be signed in to open this page"}
			redirect_to login_url
		end
	end	

	def admin_user?
		current_user.admin
	end	
	
	def admin_user
		unless admin_user?
			store_location
			flash[:notice] = {title: "Access denied", text: "You are not allowed to view this page"}
			redirect_to login_url
		end
	end

end
