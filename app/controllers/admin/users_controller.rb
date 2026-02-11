class Admin::UsersController < Admin::BaseController
  include SoftDeletableController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @q = User.not_deleted.includes(:role, :personal).ransack(params[:q])
    @users = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
    @roles = Role.all
    @personals = Personal.where.not(id: User.active.select(:personal_id))
  end

  def create
    @user = User.new(user_params)
    @roles = Role.all
    @personals = Personal.where.not(id: User.active.select(:personal_id))

    if @user.save
      # Assign current gestion to newly created user
      gestion = current_user&.current_gestion || Gestion::default
      if gestion
        @user.user_gestions.create(gestion_id: gestion.id, current: true)
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
    destroy_with_soft_delete(@user, admin_users_path, 'User')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params_hash = params.require(:user).permit(:username, :password, :password_confirmation, :role_id, :status, :personal_id, :sign_image)
    
    if params_hash[:password].blank?
      params_hash.delete(:password)
      params_hash.delete(:password_confirmation)
    end
    
    params_hash
  end
end
