class Admin::VehiclesController < Admin::BaseController
  include SoftDeletableController
  
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @q = Vehicle.not_deleted.ransack(params[:q])
    @vehicles = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @vehicle = Vehicle.new
  end

  def edit
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      redirect_to admin_vehicle_path(@vehicle), notice: t('common.created', model: 'Vehicle')
    else
      flash.now[:error] = @vehicle.errors.full_messages
      render :new
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to admin_vehicle_path(@vehicle), notice: t('common.messages.vehicle_updated')
    else
      flash.now[:error] = @vehicle.errors.full_messages
      render :edit
    end
  end

  def destroy
    destroy_with_soft_delete(@vehicle, admin_vehicles_url, 'Vehicle')
  end

  private
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:plate, :description, :details, :vehicle_type_id, :status)
    end
end
