class Admin::VehiclesController < Admin::BaseController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]

  def index
    @vehicles = Vehicle.all
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
      render :new
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to admin_vehicle_path(@vehicle), notice: 'Vehicle was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to admin_vehicles_url, notice: t('common.destroyed', model: 'Vehicle')
  end

  private
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:plate, :description, :details, :vehicle_type_id)
    end
end
