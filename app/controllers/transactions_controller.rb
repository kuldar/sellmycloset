class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_transaction, only: :show
  before_action :check_product_availability, only: [:new, :create]
  before_action :authenticate_transaction_user, only: :show

  def show
  end

  def new
    @shipping_targets = ShippingTarget.all
    @braintree_client_token = generate_client_token
    @transaction = Transaction.new
  end

  def create
    @shipping_targets = ShippingTarget.all
    shipping_target = ShippingTarget.find(params[:shipping_target_id])

    # Check if customer exists
    if current_user.has_payment_info?
      customer = Braintree::Customer.find(current_user.braintree_customer_id)
      payment_method = customer.payment_methods.find{ |payment_method| payment_method.default? }

      result = Braintree::Transaction.sale(
                  amount: @product.total_price,
                  payment_method_token: payment_method.token)

    # Else create a new customer in Vault
    else
      result = Braintree::Transaction.sale(
                  amount: @product.total_price,
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

    # If payment succeeded
    if result.success?

      # Set braintree_customer_id if it didn't exist before
      if current_user.has_payment_info?
        current_user.update(shipping_target_id: shipping_target.id)
      else
        current_user.update(
          braintree_customer_id: result.transaction.customer_details.id,
          braintree_last_4: result.transaction.credit_card_details.last_4,
          shipping_target_id: shipping_target.id
        )
      end

      # Create transaction
      @transaction = Transaction.create(
        product_id: @product.id,
        product_price_cents: @product.price_cents,
        buyer_id: current_user.id,
        seller_id: @product.user.id,
        payout_margin: @product.user.payout_margin,
        shipping_price_cents: @product.shipping_price_cents,
        shipping_target_id: shipping_target.id
      )

      if @transaction.save!
        @product.user.update_earnings(@product.earnings_cents)
        @product.sold!

        Notification.create(
              recipient: @product.user,
              actor: current_user,
              action: 'purchased',
              notifiable: @transaction)

        flash[:success] = t('.flash_success')
        redirect_to product_transaction_path
      else
        flash[:error] = @transaction.errors.full_messages.to_sentence
        render :new
      end

    # Else show errors and generate a new Braintree token
    else
      flash[:error] = result.errors
      render :new
    end

  end

  def destroy
    @product.sale.destroy!
    @product.user.update_earnings(-@product.earnings_cents)
    @product.active!

    respond_to do |format|
      format.html { redirect_to @product }
      format.js
    end
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
        :buyer_id,
        :shipping_target_id
        )
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_transaction
      @transaction = @product.sale
    end

    def check_product_availability
      redirect_to @product unless @product.active?
    end

    def authenticate_transaction_user
      redirect_to root_url unless current_user == @transaction.buyer || current_user == @transaction.seller
    end

end