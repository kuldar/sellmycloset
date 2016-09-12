class StaticPagesController < ApplicationController

	def home
		if user_signed_in? && current_user.feed.any?
			@products = current_user.feed
		else
			@products = Product.all
		end
	end

	def become_seller
	end
	
end
