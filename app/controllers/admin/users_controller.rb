class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:role, :personal).all
  end

  def show
  end

  def new
    @user = User.new
    @user.build_personal
    @roles = Role.all
  end

  def create
    @user = User.new(user_params)
    @roles = Role.all

    if @user.save
      redirect_to admin_users_path, notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @roles = Role.all
  end

  def update
    @roles = Role.all
    
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted successfully"
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to admin_users_path, alert: "Could not delete user"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params_hash = params.require(:user).permit(:email, :password, :password_confirmation, :role_id, :active,
      personal_attributes: [:id, :first_name, :last_name, :email, :phone, :ci])
    
    # If password is blank, remove it to avoid updating
    if params_hash[:password].blank?
      params_hash.delete(:password)
      params_hash.delete(:password_confirmation)
    end
    
    params_hash
  end
end
