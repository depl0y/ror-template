class StaticPagesController < ApplicationController

	layout :waiting_template, only: [:waiting]
	before_filter :check_invite, except: [:waiting]

	def home
		@contact_message = ContactMessage.new
	end
	
	def contact
	end
	
	def about
	end
	
	def terms
	end
	
end
