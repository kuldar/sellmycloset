class ShippingTargetsController < ApplicationController

  def index
    render json: ShippingTarget.in_estonia
  end

  def new
    @shipping_target = ShippingTarget.new
  end

  def create
    @shipping_target = ShippingTarget.create(shipping_target_params)
    redirect_to root_path if @shipping_target.save!
  end

  def destroy
    @shipping_target = ShippingTarget.find(params[:id])
    @shipping_target.destroy
    # @shipping_target.destroy if current_user.admin?
    redirect_to root_path if @shipping_target.destroyed?
  end

  private

    def shipping_target_params
      params.require(:shipping_target).permit(
        :name,
        :code,
        :address,
        :city,
        :country)
    end

end