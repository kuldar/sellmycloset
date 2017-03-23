class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :product
  before_destroy :clear_notifications

  validates :user_id, 
            :product_id, 
            :body, 
              presence: true

  private

    def clear_notifications
      Notification.where(notifiable: self).destroy_all
    end

end