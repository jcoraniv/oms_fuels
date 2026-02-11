class Admin::PersonalsController < Admin::BaseController
  include SoftDeletableController
  
  before_action :set_personal, only: [:show, :edit, :update, :destroy]
  before_action :set_professions, only: [:new, :create, :edit, :update]

  def index
    @personals = Personal.not_deleted.includes(:profession).all
  end

  def show
  end

  def new
    @personal = Personal.new
  end

  def create
    @personal = Personal.new(personal_params)
    if @personal.save
      redirect_to admin_personals_path, notice: 'Personal was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @personal.update(personal_params)
      redirect_to admin_personals_path, notice: 'Personal was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    destroy_with_soft_delete(@personal, admin_personals_path, 'Personal')
  end

  private

  def set_personal
    @personal = Personal.find(params[:id])
  end

  def set_professions
    @professions = Profession.all
  end

  def personal_params
    params.require(:personal).permit(:first_name, :last_name, :email, :phone, :ci, :profession_id)
  end
end
