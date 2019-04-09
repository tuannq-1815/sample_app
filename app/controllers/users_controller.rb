  class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :admin_user,  only: :destroy
  before_action :find_user, except: %i(new create index)
  before_action :correct_user,   only: %i(edit update)

  def index
    @users = User.list.page(params[:page]).per Settings.page
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
      redirect_to users_url
    else
      flash[:danger] = t ".delete_unsuccessful"
    end
  end

  private

  def find_user
    @user = User.find params[:id]
    return if @user
    flash[:error] = t ".not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    store_location
    return if logged_in?
    flash[:danger] = t ".please_log_in"
    redirect_to login_url
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end
end
