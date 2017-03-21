module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin
    before_action :set_notifications, if: :user_signed_in?

    def set_notifications
      @notifications = Notification.where(recipient: current_user).recent
    end

    def authenticate_admin
      redirect_to '/' unless current_user && access_whitelist
    end

    private
      def access_whitelist
        current_user.try(:admin?)
      end

  end
end
