class Admin::DepartmentsController < Admin::BaseController
  include SoftDeletableController
  
  before_action :set_org_structure, only: [:show, :edit, :update, :destroy]
  before_action :ensure_gestion

  def index
    @q = current_user.current_gestion.org_structures.includes(:department, parent_dept: :department).ransack(params[:q])
    @org_structures = @q.result.page(params[:page])
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
      flash.now[:error] = @org_structure.errors.full_messages
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
      flash.now[:error] = @org_structure.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    assignments = Assignment.joins(:org_position).where(org_positions: { org_structure_id: @org_structure.id })
    has_fuel_orders = assignments.any? do |assignment|
      FuelOrder.where(requester_assignment_id: assignment.id)
               .or(FuelOrder.where(approver_assignment_id: assignment.id))
               .exists?
    end
    
    if has_fuel_orders
      assignments.each(&:soft_delete)
      redirect_to admin_departments_path, notice: t('common.soft_deleted', model: 'Department')
    else
      @org_structure.destroy
      redirect_to admin_departments_path, notice: t('common.destroyed')
    end
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
