class Admin::FuelOrdersController < Admin::BaseController
  before_action :set_fuel_order, only: [:show, :edit, :update, :destroy, :approve, :complete, :cancel]
  before_action :set_assignments, only: [:new, :create, :edit, :update]
  before_action :set_vehicles, only: [:new, :create, :edit, :update]

  def index
    @fuel_orders = FuelOrder.includes(:gestion, requester_assignment: :personal, approver_assignment: :personal)
                            .where(gestion_id: current_user.current_gestion&.id)
                            .order(created_at: :desc)
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

    # Assign vehicle_id to all fuel_order_items before saving
    if @fuel_order.vehicle_id.present?
      @fuel_order.fuel_order_items.each do |item|
        item.vehicle_id = @fuel_order.vehicle_id
      end
    end

    if @fuel_order.save
      redirect_to admin_fuel_orders_path, notice: t('common.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @fuel_order.vehicle_id = @fuel_order.fuel_order_items.first&.vehicle_id
  end

  def update
    # Assign vehicle_id to all fuel_order_items before saving
    if fuel_order_params[:vehicle_id].present?
      @fuel_order.fuel_order_items.each do |item|
        item.vehicle_id = fuel_order_params[:vehicle_id]
      end
    end

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

  def approve
    @fuel_order.update(
      status: :approved,
      approved_at: Time.current,
      approver_assignment_id: current_user.personal.assignments.last&.id
    )
    redirect_to admin_fuel_orders_path, notice: 'Order approved successfully'
  end

  def complete
    @fuel_order.update(
      status: :completed,
      completed_at: Time.current
    )
    redirect_to admin_fuel_orders_path, notice: 'Order completed successfully'
  end

  def cancel
    @fuel_order.update(
      status: :canceled,
      canceled_at: Time.current
    )
    redirect_to admin_fuel_orders_path, notice: 'Order canceled successfully'
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
    params.require(:fuel_order).permit(:requester_assignment_id, :status, :vehicle_id,
      fuel_order_items_attributes: [:id, :fuel_id, :quantity_ordered, :unit_price, :_destroy])
  end

  def set_vehicles
    @vehicles = Vehicle.all
  end
end
