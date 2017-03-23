class RelationshipsController < ApplicationController
  before_action :user_signed_in?

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    Notification.create(
      recipient: @user,
      actor: current_user, 
      action: 'followed',
      notifiable: @user)
    
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

end
