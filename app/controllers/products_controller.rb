class ProductsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
	before_action :set_product, only: [:show, :edit, :update, :destroy]

	def index
		@products = Product.all
	end

	def show
		render layout: false if request.xhr?
	end

	def new
		@product = current_user.products.build
	end

	def create
    @product = current_user.products.build(product_params)

    if @product.save
      flash[:success] = t('.flash_success')
      redirect_to @product
    else
      flash[:error] = t('.flash_error')
      render 'new'
    end
	end

	def edit
  end

	def update
		if @product.update_attributes(product_params)
      flash[:success] = t('.flash_success')
      redirect_to @product
    else
      render 'edit'
    end
	end

	def destroy
		@product.destroy
		flash[:success] = t('.flash_success')
    redirect_to root_url
	end

	private

		def set_product
			@product = Product.find(params[:id])
		end

		def product_params
			params.require(:product).permit(
				:title,
				:description,
				:photo,
				:price,
				:status)
		end

end
