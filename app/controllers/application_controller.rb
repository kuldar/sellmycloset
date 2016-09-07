class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[
    	:name,
    	:username,
    	:email,
    	:password,
      :password_confirmation,
      :remember_me,
      :avatar,
      :remote_avatar_url,
      :cover,
      :about,
    ])

    devise_parameter_sanitizer.permit(:account_update, keys:[
    	:name,
    	:username,
    	:email,
    	:password,
      :password_confirmation,
      :current_password,
      :avatar,
      :remote_avatar_url,
      :cover,
      :about,
    ])
  end
end
