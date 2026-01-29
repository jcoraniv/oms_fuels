class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.not_deleted.includes(:role, :personal).all
  end

  def show
  end

  def new
    @user = User.new
    @roles = Role.all
    @personals = Personal.where.not(id: User.select(:personal_id))
  end

  def create
    @user = User.new(user_params)
    @roles = Role.all
    @personals = Personal.where.not(id: User.select(:personal_id))

    if @user.save
      # Assign active gestion to newly created user
      active_gestion = Gestion.find_by(active: true)
      if active_gestion
        @user.user_gestions.create(gestion_id: active_gestion.id, current: true)
      end
      redirect_to admin_users_path, notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @roles = Role.all
    @personals = Personal.where.not(id: User.where.not(id: @user.id).select(:personal_id))
  end

  def update
    @roles = Role.all
    @personals = Personal.where.not(id: User.where.not(id: @user.id).select(:personal_id))
    
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.soft_delete
    redirect_to admin_users_path, notice: "User deleted successfully"
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to admin_users_path, alert: "Could not delete user"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params_hash = params.require(:user).permit(:email, :password, :password_confirmation, :role_id, :status, :personal_id)
    
    if params_hash[:password].blank?
      params_hash.delete(:password)
      params_hash.delete(:password_confirmation)
    end
    
    params_hash
  end
end
