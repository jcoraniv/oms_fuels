class Admin::FuelOrdersController < Admin::BaseController
  before_action :set_fuel_order, only: [:show, :edit, :update, :destroy]
  before_action :set_assignments, only: [:new, :create, :edit, :update]

  def index
    @fuel_orders = FuelOrder.includes(:gestion, requester_assignment: :personal).all
  end

  def show
  end

  def new
    @fuel_order = FuelOrder.new
    # Default to current gestion if available
    @fuel_order.gestion = current_user.current_gestion if current_user&.current_gestion
  end

  def create
    @fuel_order = FuelOrder.new(fuel_order_params)
    # Ensure gestion is set correctly, preferably from the current context
    @fuel_order.gestion = current_user.current_gestion if current_user&.current_gestion

    if @fuel_order.save
      redirect_to admin_fuel_orders_path, notice: t('common.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @fuel_order.update(fuel_order_params)
      redirect_to admin_fuel_orders_path, notice: t('common.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @fuel_order.destroy
    redirect_to admin_fuel_orders_path, notice: t('common.destroyed')
  end

  private

  def set_fuel_order
    @fuel_order = FuelOrder.find(params[:id])
  end

  def set_assignments
    # Load assignments for the current gestion to populate dropdowns
    # This assumes we have assignments created. If not, the dropdown will be empty.
    gestion_id = current_user&.current_gestion&.id
    @assignments = Assignment.includes(:personal, :org_position).where(org_positions: { org_structures: { gestion_id: gestion_id } })
                             .joins(org_position: :org_structure)
  end

  def fuel_order_params
    params.require(:fuel_order).permit(:requester_assignment_id, :total, :status)
  end
end
