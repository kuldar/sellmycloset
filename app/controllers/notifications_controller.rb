class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @unread_notifications.update_all(read_at: Time.zone.now)
  end

  def mark_as_read
    @unread_notifications.update_all(read_at: Time.zone.now)
    render json: { success: true }
  end

end