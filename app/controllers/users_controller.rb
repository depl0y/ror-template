require 'bcrypt'


class UsersController < ApplicationController
	before_action :set_user, only: [:show]
	before_action :signed_in_user, only: [:show, :edit, :update, :destroy, :index]
	before_action :correct_user, only: [:show]
	before_action :admin_user, only: [:index]

	def new
		session["accountNumber"] = nil
		session["userEmail"] = nil
		session["userName"] = nil

		@user = User.new

		@provided_name = ""
		@provided_email = ""
		@account_number = ""

		if session["devise.facebook_data"] && session["devise.facebook_data"].info.name
			@provided_name = session["devise.facebook_data"].info.name
		end

		if session["devise.facebook_data"] && session["devise.facebook_data"].info.email
			@provided_email = session["devise.facebook_data"].info.email
		end

		if !session["userEmail"].nil?
			@provided_email = session["userEmail"]
		end

		if !session["userName"].nil?
			@provided_name = session["userName"]
		end

	end

	def index
		@users = User.order("created_at DESC").page(params[:page]).per(10);
	end

	def show

		if session["devise.facebook_data"] && session["devise.facebook_data"].uid

			@found_user = User.find_by_uid(session["devise.facebook_data"].uid)
			if !@found_user.nil?
				@found_user = @found_user.where(:provider => "facebook")
			end

			if @found_user
				flash[:error] = "Dit facebook account is al een ander account verbonden"
			else
				@current_user.uid = session["devise.facebook_data"].uid
				@current_user.provider = "facebook"
				@current_user.provider_info = session["devise.facebook_data"]

				@current_user.save
				session["devise.facebook_data"] = nil

				flash[:success] = "Facebook succesvol verbonden aan dit account"
			end
		end

		@messages = []
		@requests = Request.where("user_id = ?", @current_user.id).order("created_at DESC").first(5)
		@received = Request.where("destination_user_id = ?", @current_user.id).order("created_at DESC").first(5)
	end

	# POST /users
	# POST /users.json
	def create
		@user = User.new(user_params)

		@user.accountNumber.gsub(" ", "")
		@user.provider = nil

		if session["devise.facebook_data"] && session["devise.facebook_data"].uid

			@found_user = User.find_by_uid(session["devise.facebook_data"].uid)
			if !@found_user.nil?
				@found_user = @found_user.where(:provider => "facebook")
			end

			if !@found_user.nil?
				flash[:error] = "Dit facebook account is al aan een ander account verbonden"
				redirect_to signup_path and return
			else
				@user.uid = session["devise.facebook_data"].uid

				@pwd = Devise.friendly_token[0, 20]

				@user.password = @pwd
				@user.password_confirmation = @pwd
				@user.provider = "facebook"
				@user.provider_info = session["devise.facebook_data"]
			end
		end

		session["userEmail"] = @user.email
		session["userName"] = @user.name

		@found_user = User.find_by_email(@user.email)
		if @found_user
			flash[:error] = "Een gebruiker met dit email adres bestaat al"
			render action: "new" and return
		end

		respond_to do |format|
			if @user.save
				if @user.provider == nil
					UserMailer.welcome_email(@user).deliver
				else
					UserMailer.welcome_email_provider(@user).deliver
				end

				session["devise.facebook_data"] = nil
				session["userEmail"] = nil
				session["userName"] = nil

				sign_in(@user)

				format.html {
					flash[:notice] = {title: "Account aangemaakt", text: "Er is een account voor u aangemaakt, u kunt hier nu mee inloggen."}
					redirect_to profile_path
				}
				format.json { render action: 'show', status: :created, location: @user }
			else
				format.html { render action: "new" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /users/1
	# PATCH/PUT /users/1.json
	def update

		@user = current_user

		if @user.provider.nil? and params[:current_password].blank?
			@user.errors.add(:current_password, "is nodig om gegevens te kunnen wijzigen")
			flash[:error] = "U moet uw huidige wachtwoord opgeven om gegevens te kunnen wijzigen"
			render action: "edit" and return
		end

		@found_user = User.find_by_email(params[:user][:email])
		if @found_user and @found_user.id != @current_user.id
			@user.errors.add(:email, "is al in gebruik")
			render action: "edit" and return
		end


		if @user.provider or valid_password?(params[:current_password])
			respond_to do |format|
				if @user.update_attributes(user_params)
					format.html { redirect_to @user, success: 'User was successfully updated.' }
					format.json { head :no_content }
				else
					format.html { render action: 'edit' }
					format.json { render json: @user.errors, status: :unprocessable_entity }
				end
			end
		else
			respond_to do |format|
				flash[:notice] = {title: "Aanpassinging niet opgeslagen",
								  text: "Het opgegeven huidige wachtwoord klopt niet, de wijzigingen konden daarom niet worden opgeslagen."}

				flash[:error] = "Uw huidige wachtwoord klopt niet"
				format.html { render action: "edit" }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	def destroy
		@user.destroy
		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :no_content }
		end
	end

	# GET /users/1/edit
	def edit
		@user = current_user

		@provided_name = @user.name
		@provided_email = @user.email


	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_user
		if (params.has_key?(:id))
			@user = User.find(params[:id])
		else
			@user = current_user
		end
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def user_params
		params.require(:user).permit(:email, :name, :password, :password_confirmation, :new_password, :new_password_confirmation, :password_reset_token, :password_reset_at)
	end

	def correct_user
		if (params.has_key?(:id))
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		else
			set_user
		end
	end

	def needs_password?(user, params)
		user.accountNumber != params[:user][:accountNumber] || user.email != params[:user][:accountNumber]
	end
end
