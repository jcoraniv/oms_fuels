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
    @fuel_order.gestion = current_user.current_gestion if current_user&.current_gestion
    @fuel_order.fuel_order_items.build # Build one item by default
  end

  def create
    @fuel_order = FuelOrder.new(fuel_order_params)
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
    gestion_id = current_user&.current_gestion&.id
    @assignments = Assignment.includes(:personal, :org_position).where(org_positions: { org_structures: { gestion_id: gestion_id } })
                             .joins(org_position: :org_structure)
  end

  def fuel_order_params
    params.require(:fuel_order).permit(:requester_assignment_id, :status,
      fuel_order_items_attributes: [:id, :quantity_ordered, :unit_price, :_destroy])
  end
end
