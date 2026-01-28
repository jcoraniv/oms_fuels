class Admin::DepartmentsController < Admin::BaseController
  before_action :set_org_structure, only: [:show, :edit, :update, :destroy]
  before_action :ensure_gestion

  def index
    @org_structures = current_user.current_gestion.org_structures.includes(:department, parent_dept: :department)
  end

  def show
  end

  def new
    @org_structure = current_user.current_gestion.org_structures.build
    @org_structure.build_department
    @parent_departments = current_user.current_gestion.org_structures.includes(:department)
  end

  def create
    @org_structure = current_user.current_gestion.org_structures.build(org_structure_params)
    if @org_structure.save
      redirect_to admin_departments_path, notice: t('common.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @parent_departments = current_user.current_gestion.org_structures.where.not(id: @org_structure.id).includes(:department)
  end

  def update
    if @org_structure.update(org_structure_params)
      redirect_to admin_departments_path, notice: t('common.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @org_structure.destroy
    redirect_to admin_departments_path, notice: t('common.destroyed')
  end

  private

  def set_org_structure
    @org_structure = current_user.current_gestion.org_structures.find(params[:id])
  end

  def org_structure_params
    params.require(:org_structure).permit(:parent_dept_id, department_attributes: [:id, :name])
  end

  def ensure_gestion
    unless current_user.current_gestion
      redirect_to select_gestion_path, alert: 'Please select a gestion first'
    end
  end
end
