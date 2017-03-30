class RegistrationsController < Devise::RegistrationsController

  def edit
    @shipping_targets = ShippingTarget.in_estonia
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end