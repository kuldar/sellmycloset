class ProductsController < ApplicationController
	before_action :set_product, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_seller, only: [:new, :create]
	before_action :authenticate_product_seller, only: [:edit, :update, :destroy]

	def index
		if params.has_key?(:q)
    	@products = Product.tagged_with(params[:q], any: true)
    else
    	@products = Product.all.active
    end
	end

	def show
		render layout: false if request.xhr?
	end

	def new
		@product = current_user.products.build
		@product_image = @product.product_images.build
	end

	def create
    @product = current_user.products.build(product_params)

    if @product.save && save_images
  		flash[:success] = t('.flash_success', short_url: product_url(@product))
    	redirect_to @product
  	else
      flash[:error] = t('.flash_error')
      render 'new'
	  end

	end

	def edit
  end

  # Todo, update update method with product_images support
	def update
		if @product.update_attributes(product_params)
			save_images
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

		def authenticate_seller
			redirect_to root_url if current_user.buyer?
		end

		def authenticate_product_seller
			current_user == @product.user
		end

		def product_params
			params.require(:product).permit(
				:title,
				:description,
				:price,
				:status,
				:category,
				:tag_list,
				product_images_attributes: [:id, :product_id, :image])
		end

		def save_images
			unless params[:product_images].blank?
				params[:product_images]['image'].each do |image|
    			@product_image = @product.product_images.create!(image: image)
    		end
    	end
		end

end
