class PaymentsController < ApplicationController
	before_action :authenticate_user!

	# Create new payment with nonce
	def create

		@product = Product.first

		# Check if customer exists
		if current_user.has_payment_info?
			customer = Braintree::Customer.find(current_user.braintree_customer_id)
			payment_method = customer.payment_methods.find{ |payment_method| payment_method.default? }

			result = Braintree::Transaction.sale(
									amount: '10.00',
									payment_method_token: payment_method.token,
									custom_fields: {
										product_name: 'Adidase dressid',
										seller_id: '123',
										})

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
									},
									custom_fields: {
										product_name: 'Adidase dressid',
										seller_id: '123',
									})
		end

		# If payment succeeded finalize purchase
		# Set braintree_customer_id if it didn't exist before
		if result.success?
			unless current_user.has_payment_info?
				current_user.update(braintree_customer_id: result.transaction.customer_details.id)
			end

			current_user.purchase(@product)!
			redirect_to @product, notice: 'Edukas ost!'

		# Else show errors and generate a new Braintree token
		else
			# generate_client_token # And send it to the view
			render :new, notice: 'Probleem ostuga'
		end
	end

end