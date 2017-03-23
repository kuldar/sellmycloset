class Like < ApplicationRecord
  
  belongs_to :user
  belongs_to :product
  before_destroy :clear_notifications

  private

    def clear_notifications
      Notification.where("action = ? AND actor_id = ? AND notifiable_id = ?", 'liked', self.user_id, self.product_id).destroy_all  
    end

end
