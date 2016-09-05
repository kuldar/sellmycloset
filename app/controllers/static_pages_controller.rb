class StaticPagesController < ApplicationController

	def home
		if user_signed_in?
			@products = current_user.feed
		else
			@products = Product.all
		end
	end

end
