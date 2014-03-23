class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.order(:name).page params[:page]
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.page params[:page]
  end

  def new
    unless signed_in?
      @user = User.new
    else
      redirect_to root_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, flash: { success: 'Profile updated' }
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      redirect_to @user, flash: { success: 'Welcome to the sample app!' }
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy unless @user.admin?
    redirect_to users_url, flash: { success: 'User destroyed.' }
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
