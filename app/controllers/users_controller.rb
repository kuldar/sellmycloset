class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers, :sales, :purchases, :likes]
  before_action :authenticate_purchases_user, only: :purchases

  def index
    @users = User.all
  end

  def show
  end

  def likes
    @view_title = 'Minu meeldimised'
    @products = @user.liked_products
    render 'liked_products'
  end

  def following
    @view_title = 'Keda ma fännan'
    @users = @user.following
    render 'users_list'
  end

  def followers
    @view_title = 'Minu fännid'
    @users = @user.followers
    render 'users_list'
  end

  def sales
    @view_title = 'Minu müügid'
    @transactions = @user.sales
    render 'transactions/transactions_list'
  end

  def purchases
    @view_title = 'Minu ostud'
    @transactions = @user.purchases
    render 'transactions/transactions_list'
  end

  def become_seller
    current_user.seller!
    flash[:success] = t('user.become_seller.flash_success')
    redirect_to root_path
  end

  private

    def set_user
      @user = User.find_by_username(params[:id])
    end

    def authenticate_purchases_user
      redirect_to root_url unless current_user == @user
    end

end
