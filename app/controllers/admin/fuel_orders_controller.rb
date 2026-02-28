class Admin::FuelOrdersController < Admin::BaseController
  before_action :set_fuel_order, only: [:show, :edit, :update, :destroy, :approve, :complete, :cancel]
  before_action :set_assignments, only: [:new, :create, :edit, :update]
  before_action :set_vehicles, only: [:new, :create, :edit, :update]

  def index
    @q = policy_scope(FuelOrder).includes(:gestion, requester_assignment: :personal, approver_assignment: :personal).ransack(params[:q])
    @fuel_orders = @q.result
    @fuel_orders = @fuel_orders.where(status: params[:status]) if params[:status].present?
    @fuel_orders = @fuel_orders.order(created_at: :desc).page(params[:page])
  end

  def show
    authorize @fuel_order
    respond_to do |format|
      format.html
      format.pdf do
        # Preload attachments
        @fuel_order.requester_sign.attachment if @fuel_order.requester_sign.attached?
        @fuel_order.approver_sign.attachment if @fuel_order.approver_sign.attached?
        
        pdf = FuelOrderPdf.new(@fuel_order)
        filename = "#{@fuel_order.formatted_number}_#{@fuel_order.created_at.strftime('%Y%m%d')}.pdf"
        send_data pdf.render, filename: filename, type: "application/pdf", disposition: "inline"
      end
    end
  end

  def new
    @fuel_order = FuelOrder.new
    authorize @fuel_order
    @fuel_order.gestion = current_user.current_gestion if current_user&.current_gestion
    @fuel_order.requester_assignment_id = current_user.personal.assignments.last&.id if current_user.employee?
    @fuel_order.fuel_order_items.build # Build one item by default
  end

  def create
    retries = 0
    begin
      FuelOrder.transaction do
        @fuel_order = FuelOrder.new(fuel_order_params)
        authorize @fuel_order
        @fuel_order.gestion = current_user.current_gestion if current_user&.current_gestion
        @fuel_order.requester_assignment_id = current_user.personal.assignments.last&.id if current_user.employee?

        # Assign vehicle_id to all fuel_order_items before saving
        if @fuel_order.vehicle_id.present?
          @fuel_order.fuel_order_items.each do |item|
            item.vehicle_id = @fuel_order.vehicle_id
          end
        end

        # Copy requester signature
        if current_user.sign_image.attached?
          @fuel_order.requester_sign.attach(
            io: StringIO.new(current_user.sign_image.download),
            filename: current_user.sign_image.filename.to_s,
            content_type: current_user.sign_image.content_type
          )
        end

        @fuel_order.save!
        WebPushService.notify_new_order(@fuel_order)
        redirect_to admin_fuel_orders_path, notice: t('common.created')
      end
    rescue ActiveRecord::RecordNotUnique
      retries += 1
      if retries <= 3
        @fuel_order.number = nil
        retry
      else
        flash.now[:error] = 'Unable to generate order number. Please try again.'
        @fuel_order.errors.add(:base, 'Unable to generate order number. Please try again.')
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @fuel_order.custom_error_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @fuel_order
    @fuel_order.vehicle_id = @fuel_order.fuel_order_items.first&.vehicle_id
  end

  def update
    authorize @fuel_order
    @fuel_order.requester_assignment_id = current_user.personal.assignments.last&.id if current_user.employee?
    
    # Assign vehicle_id to all fuel_order_items before saving
    if fuel_order_params[:vehicle_id].present?
      @fuel_order.fuel_order_items.each do |item|
        item.vehicle_id = fuel_order_params[:vehicle_id]
      end
    end

    if @fuel_order.update(fuel_order_params)
      redirect_to admin_fuel_orders_path, notice: t('common.updated')
    else
      flash.now[:error] = @fuel_order.custom_error_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @fuel_order
    @fuel_order.destroy
    redirect_to admin_fuel_orders_path, notice: t('common.destroyed')
  end

  def approve
    authorize @fuel_order
    
    # Copy approver signature before updating
    if current_user.sign_image.attached?
      @fuel_order.approver_sign.attach(
        io: StringIO.new(current_user.sign_image.download),
        filename: current_user.sign_image.filename.to_s,
        content_type: current_user.sign_image.content_type
      )
    end
    
    @fuel_order.assign_attributes(
      status: :approved,
      approved_at: Time.current,
      approver_assignment_id: current_user.personal.assignments.last&.id
    )
    
    if @fuel_order.save
      redirect_back(fallback_location: admin_fuel_orders_path, notice: t('common.messages.order_approved'))
    else
      redirect_back(fallback_location: admin_fuel_orders_path, alert: @fuel_order.errors.full_messages.join(', '))
    end
  end

  def complete
    authorize @fuel_order
    @fuel_order.update(
      status: :completed,
      completed_at: Time.current
    )
    redirect_back(fallback_location: admin_fuel_orders_path, notice: t('common.messages.order_completed'))
  end

  def cancel
    authorize @fuel_order
    @fuel_order.update_columns(
      status: :canceled,
      canceled_at: Time.current,
      approver_assignment_id: current_user.personal.assignments.last&.id
    )
    redirect_back(fallback_location: admin_fuel_orders_path, notice: t('common.messages.order_canceled'))
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
    permitted_params = params.require(:fuel_order).permit(:requester_assignment_id, :approver_assignment_id, :status, :vehicle_id,
      fuel_order_items_attributes: [:id, :fuel_id, :quantity_ordered, :unit_price, :_destroy])
    
    # Set unit_price from fuel reference_price if user is Employee role
    if current_user.employee? && permitted_params[:fuel_order_items_attributes]
      permitted_params[:fuel_order_items_attributes].each do |_, item_attrs|
        if item_attrs[:fuel_id].present?
          fuel = Fuel.find_by(id: item_attrs[:fuel_id])
          item_attrs[:unit_price] = fuel.reference_price if fuel
        end
      end
    end
    
    permitted_params
  end

  def set_vehicles
    @vehicles = Vehicle.not_deleted
  end
end
