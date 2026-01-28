class Admin::PositionsController < Admin::BaseController
  before_action :set_org_position, only: [:show, :edit, :update, :destroy]
  before_action :ensure_gestion

  def index
    @org_positions = current_user.current_gestion.org_positions.includes(:position, :org_structure, assignments: :personal)
  end

  def show
    @assignments = @org_position.assignments.includes(:personal)
  end

  def new
    @org_position = OrgPosition.new
    @org_position.build_position
    @org_structures = current_user.current_gestion.org_structures.includes(:department)
    @personals = Personal.all
  end

  def create
    @org_position = OrgPosition.new(org_position_params)
    if @org_position.save
      redirect_to admin_positions_path, notice: t('common.created')
    else
      @org_structures = current_user.current_gestion.org_structures.includes(:department)
      @personals = Personal.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @org_structures = current_user.current_gestion.org_structures.includes(:department)
    @personals = Personal.all
    @org_position.assignments.build if @org_position.assignments.empty?
  end

  def update
    if @org_position.update(org_position_params)
      redirect_to admin_positions_path, notice: t('common.updated')
    else
      @org_structures = current_user.current_gestion.org_structures.includes(:department)
      @personals = Personal.all
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
