class TransactionsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_product
	before_action :check_product_availability, only: [:new, :create]

	def show
		@transaction = @product.sale
	end

	def new
		@braintree_client_token = generate_client_token
		@transaction = Transaction.new
	end

	def create

		# Check if customer exists
		if current_user.has_payment_info?
			customer = Braintree::Customer.find(current_user.braintree_customer_id)
			payment_method = customer.payment_methods.find{ |payment_method| payment_method.default? }

			result = Braintree::Transaction.sale(
									amount: '10.00',
									payment_method_token: payment_method.token)

		# Else create a new customer in Vault
		else
			result = Braintree::Transaction.sale(
									amount: '10.00',
									payment_method_nonce: params[:payment_method_nonce],
									customer: {
										first_name: current_user.first_name,
										last_name: current_user.last_name,
										email: current_user.email,
									},
									options: {
										store_in_vault: true
									})
		end

		# If payment succeeded finalize purchase
		# Set braintree_customer_id if it didn't exist before
		if result.success?
			unless current_user.has_payment_info?
				current_user.update(braintree_customer_id: result.transaction.customer_details.id)
			end

			@transaction = current_user.purchase(@product)
			@product.sold!

	    if @transaction.save
	  		flash[:success] = t('.flash_success')
	    	redirect_to product_transaction_path
	  	else
	      flash[:error] = t('.flash_error')
	      render :new
		  end

		# Else show errors and generate a new Braintree token
		else
			flash[:error] = 'Errrror!'
			render :new
		end

	end

	def destroy
		@transaction = Transaction.find(params[:transaction_id])
		@transaction.destroy!
	end

	def generate_client_token
		if current_user.has_payment_info?
			Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
		else
			Braintree::ClientToken.generate
		end
	end

	private

		def transaction_params
			params.require(:transaction).permit(
				:product_id,
				:seller_id,
				:buyer_id)
		end

		def set_product
			@product = Product.find(params[:product_id])
		end

		def check_product_availability
			redirect_to @product unless @product.active?
		end

end