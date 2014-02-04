class API::V1::UsersController < ApiController

	def new

		@user = User.new

		@provider_name = ""
		@provider_email = ""
		@provider_uid = ""

	end

	def create
		respond_to do |format|
			@user = User.new(user_params)

			@user.provider = nil

			@found_user = User.find_by_email(@user.email)
			if @found_user
				format.json { render :json => {:status => "error", :message => "A user with this email address already exists"} } and return
			end

			if !params[:uid].nil? && !params[:provider].nil?
				@found_user = User.where("uid = ? AND provider = ?", params[:uid], params[:provider])

				if @found_user
					format.json { render :json => {:status => "error", :message => "A user with this account already exists"} } and return
				else
					@user.uid = params[:uid]

					@pwd = Devise.friendly_token[0, 20]

					@user.password = @pwd
					@user.password_confirmation = @pwd
					@user.provider = params[:provider]
					@user.provider_info = nil

				end
			end

			if @user.save
				UserMailer.welcome_email(@user).deliver

				format.json { render :json => {:status => "ok"} } and return

			end

		end

	end


	private

	def user_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation, :new_password, :new_password_confirmation, :password_reset_token, :password_reset_at)
	end

end