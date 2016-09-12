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

	def ssl
		render text: 'sD-oifpWzh77olnVSCvltu4EBzCpjuQyJQqexCebsD0._bi8bW4zVMp0OQTWNMyTaIZS5hPvE4U1K13UOEkEO9Y'
	end

end
