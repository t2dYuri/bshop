class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_only,     only: [:index, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(initial_user_params)
    if @user.save
      log_in @user
      redirect_to @user
      flash[:success] = "Welcome, #{@user.name}"
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted successfuly'
    redirect_to users_url
  end

  private

  def initial_user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_params
    if current_user && current_user.admin?
      params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                   :zip_code, :country, :region, :city, :phone, :address)
    else
      params.require(:user).permit(:name, :password, :password_confirmation,
                                   :zip_code, :country, :region, :city, :phone, :address)
    end
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'For registered users only'
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to store_url unless current_user?(@user) || current_user.admin?
  end

  # def admin_user
  #   redirect_to store_url unless current_user.try(:admin?)
  # end

end
