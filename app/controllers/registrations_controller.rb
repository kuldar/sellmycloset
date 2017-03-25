class RegistrationsController < Devise::RegistrationsController

  def edit
    @shipping_targets = ShippingTarget.in_estonia
    @braintree_client_token = current_user.has_payment_info? ? Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id) : Braintree::ClientToken.generate
  end

  def update
    super
    unless current_user.has_payment_info?
      result = Braintree::Customer.create(
        first_name: current_user.first_name,
        last_name: current_user.last_name,
        email: current_user.email,
        credit_card: {
          payment_method_nonce: params[:payment_method_nonce],
          options: { verify_card: true }
        }
      )

      if result.success?
        current_user.update(
          braintree_customer_id: result.customer.id,
          braintree_last_4: result.customer.payment_methods[0].last_4
        )
      else
        flash[:error] = result.errors
      end
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    # user_path(resource)
  end
end