class StaticPagesController < ApplicationController
	before_action :authenticate_user!, only: :become_seller

	def home
		@products = Product.active
	end

  def join
  end

	def become_seller
	end
	
end
