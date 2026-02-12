class Admin::PositionsController < Admin::BaseController
  before_action :set_org_position, only: [:show, :edit, :update, :destroy]
  before_action :ensure_gestion

  def index
    @q = current_user.current_gestion.org_positions.includes(:position, :org_structure, assignments: :personal).ransack(params[:q])
    @org_positions = @q.result.page(params[:page])
  end

  def show
    @assignments = @org_position.assignments.includes(:personal)
  end

  def new
    @org_position = OrgPosition.new
    @org_position.build_position
    @org_position.assignments.build
    @org_structures = current_user.current_gestion.org_structures.includes(:department)
    @personals = Personal.where.not(id: Assignment.joins(org_position: :org_structure).where(org_structures: { gestion_id: current_user.current_gestion.id }).select(:personal_id))
  end

  def create
    @org_position = OrgPosition.new(org_position_params)
    if @org_position.save
      redirect_to admin_positions_path, notice: t('common.created')
    else
      flash.now[:error] = @org_position.errors.full_messages
      @org_structures = current_user.current_gestion.org_structures.includes(:department)
      @personals = Personal.where.not(id: Assignment.joins(org_position: :org_structure).where(org_structures: { gestion_id: current_user.current_gestion.id }).select(:personal_id))
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @org_structures = current_user.current_gestion.org_structures.includes(:department)
    @personals = Personal.where.not(id: Assignment.joins(org_position: :org_structure).where(org_structures: { gestion_id: current_user.current_gestion.id }).where.not(org_position_id: @org_position.id).select(:personal_id))
    @org_position.assignments.build if @org_position.assignments.empty?
  end

  def update
    if @org_position.update(org_position_params)
      redirect_to admin_positions_path, notice: t('common.updated')
    else
      flash.now[:error] = @org_position.errors.full_messages
      @org_structures = current_user.current_gestion.org_structures.includes(:department)
      @personals = Personal.where.not(id: Assignment.joins(org_position: :org_structure).where(org_structures: { gestion_id: current_user.current_gestion.id }).where.not(org_position_id: @org_position.id).select(:personal_id))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @org_position.destroy
    redirect_to admin_positions_path, notice: t('common.destroyed')
  end

  private

  def set_org_position
    @org_position = current_user.current_gestion.org_positions.find(params[:id])
  end

  def org_position_params
    params.require(:org_position).permit(
      :org_structure_id, 
      position_attributes: [:id, :code, :name, :status],
      assignments_attributes: [:id, :personal_id, :start_date, :end_date, :_destroy]
    )
  end

  def ensure_gestion
    unless current_user.current_gestion
      redirect_to select_gestion_path, alert: 'Please select a gestion first'
    end
  end
end
