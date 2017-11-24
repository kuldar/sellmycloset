class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers, :sales, :purchases, :likes]
  before_action :authenticate_purchases_user, only: :purchases

  def index
    @users = User.all
  end

  def show
  end

  def likes
    @view_title = t('user.my_likes')
    @products = @user.liked_products
    render 'liked_products'
  end

  def sellers
    @users = User.sellers
  end

  def following
    @view_title = t('user.my_followings')
    @users = @user.following
    render 'users_list'
  end

  def followers
    @view_title = t('user.my_followers')
    @users = @user.followers
    render 'users_list'
  end

  def sales
  end

  def purchases
    @view_title = t('user.my_purchases')
    @purchases = @user.purchases
  end

  def become_seller
    current_user.seller!
    redirect_to new_product_path
  end

  def avatar
    current_user.update_attribute(:avatar, params[:user][:avatar])
    render json: { avatar_url: current_user.avatar_url(:medium, public: true) }
  end

  def cover
    current_user.update_attribute(:cover, params[:user][:cover])
    render json: { cover_url: current_user.cover_url(:medium, public: true) }
  end

  private

    def set_user
      @user = User.find_by_username(params[:id])
    end

    def authenticate_purchases_user
      redirect_to root_url unless current_user == @user
    end

end
