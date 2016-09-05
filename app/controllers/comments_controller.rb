class CommentsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_product

	def create
		@comment = @product.comments.build(comment_params)
		
		respond_to do |format|
			if @comment.save!
				format.html { redirect_to @product }
				format.js
			else
				format.html
				format.js { render js: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy! if current_user == @comment.user

		respond_to do |format|
			if @comment.destroyed?
				format.html { redirect_to @product }
				format.js
			else
				format.html
				format.js { render js: @comment.errors, status: :unprocessable_entity }
			end
		end
	end

	private

		def comment_params
			params.require(:comment).permit(
				:body,
				:product_id,
				:user_id)
		end

		def set_product
			@product = Product.find(params[:product_id])
		end

end