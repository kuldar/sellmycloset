class Relationship < ApplicationRecord

	belongs_to :follower, class_name: 'User'
	belongs_to :followed, class_name: 'User'

	validates :follower_id, presence: true
	validates :followed_id, presence: true

  before_destroy :clear_notifications

  private

    def clear_notifications
      Notification.where("action = ? AND actor_id = ? AND notifiable_id = ?", 'followed', self.follower_id, self.followed_id).destroy_all
    end

end
