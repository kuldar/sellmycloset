class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_transaction, only: [:show, :mark_paid, :mark_shipped, :mark_received]
  before_action :check_product_availability, only: [:new, :create]
  before_action :authenticate_transaction_user, only: :show

  def show
  end

  def new
    @shipping_targets = ShippingTarget.in_estonia
    @transaction = Transaction.new
  end

  def create
    @shipping_targets = ShippingTarget.in_estonia
    shipping_target = ShippingTarget.find(params[:shipping_target_id])

    current_user.update(phone_number: params[:phone_number]) unless current_user.phone_number?

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

  def mark_paid
    @transaction.paid!
    redirect_to product_transaction_path
  end

  def mark_shipped
    @transaction.shipped!
    redirect_to product_transaction_path
  end

  def mark_received
    @transaction.received!
    redirect_to product_transaction_path
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