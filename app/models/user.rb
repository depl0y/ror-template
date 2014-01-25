class User < ActiveRecord::Base
	devise :omniauthable, :omniauth_providers => [:facebook]

	before_save :save_action
	before_create :create_remember_token

	has_secure_password

	validates :new_password, :length => {:within => 6..64},
			  :confirmation => true,
			  :presence => true,
			  :if => :password_changed?

	validates :name, presence: true
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

	attr_accessor :new_password, :new_password_confirmation
	validates_confirmation_of :new_password, :if => :password_changed?

	serialize :provider_info, Hash

	def avatar_url

		if !provider_info.nil? and provider_info.kind_of?(Hash) and !provider_info[:info].nil? and !provider_info[:info][:image].nil?
			provider_info.info.image
		else
			default_url = "http://App.nl/images/unknownuser_48.png"
			gravatar_id = Digest::MD5.hexdigest(email.downcase)
			"http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
		end
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def password_changed?
		!@new_password.blank?
	end

	def self.authenticate(email, password)
		if user = find_by_email(email)
			if BCrypt::Password.new(user.password_digest).is_password? password_changed?()
				return user
			end
		end

		return nil
	end

	def send_password_reset
		generate_token(:password_reset_token)
		self.password_reset_at = Time.zone.now
		save!
		UserMailer.password_reset(self).deliver
	end

	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
		user = User.where(:provider => auth.provider, :uid => auth.uid).first
		unless user
			user = User.create(name: auth.extra.raw_info.name,
							   provider: auth.provider,
							   uid: auth.uid,
							   email: auth.info.email,
							   password: Devise.friendly_token[0, 20])
		end
		return user
	end

	private
	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end

	def save_action
		self.email = email.downcase
		if password_changed?
			self.password = @new_password
			self.password_confirmation = @new_password
		end
	end

	def hash_new_password
		self.password_digest = BCrypt::Password.create(@new_password)
	end

	def create_remember_token
		self.remember_token = User.encrypt(User.new_remember_token)
	end
end

#class IbanValidator < ActiveModel::EachValidator

#	def validate_each(record, attribute, value)
#	end

#end