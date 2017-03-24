class RegistrationsController < Devise::RegistrationsController

  def edit
    @shipping_targets = ShippingTarget.all
    @braintree_client_token = current_user.has_payment_info? ? Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id) : Braintree::ClientToken.generate
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    # user_path(resource)
  end
end