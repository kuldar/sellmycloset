class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def set_locale
      I18n.locale = params[:locale] # if nil, then I18n.default_locale will be used
    end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[
    	:name,
    	:username,
    	:email,
      :phone_number,
    	:password,
      :password_confirmation,
      :remember_me,
      :avatar,
      :facebook_handle,
      :instagram_handle,
      :payout_name,
      :payout_iban,
      :available_balance,
      :pending_balance,
      :total_earnings,
      :cover,
      :about,
    ])

    devise_parameter_sanitizer.permit(:account_update, keys:[
    	:name,
    	:username,
    	:email,
      :phone_number,
    	:password,
      :password_confirmation,
      :current_password,
      :avatar,
      :facebook_handle,
      :instagram_handle,
      :payout_name,
      :payout_iban,
      :available_balance,
      :pending_balance,
      :total_earnings,
      :cover,
      :about,
    ])
  end
end
