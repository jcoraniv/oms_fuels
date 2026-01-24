class Admin::VehicleTypesController < Admin::BaseController
  before_action :set_vehicle_type, only: [:show, :edit, :update, :destroy]

  def index
    @vehicle_types = VehicleType.all
  end

  def show
  end

  def new
    @vehicle_type = VehicleType.new
  end

  def edit
  end

  def create
    @vehicle_type = VehicleType.new(vehicle_type_params)

    if @vehicle_type.save
      redirect_to admin_vehicle_type_path(@vehicle_type), notice: t('common.created', model: 'Vehicle type')
    else
      render :new
    end
  end

  def update
    if @vehicle_type.update(vehicle_type_params)
      redirect_to admin_vehicle_type_path(@vehicle_type), notice: 'Vehicle type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @vehicle_type.destroy
    redirect_to admin_vehicle_types_url, notice: t('common.destroyed', model: 'Vehicle type')
  end

  private
    def set_vehicle_type
      @vehicle_type = VehicleType.find(params[:id])
    end

    def vehicle_type_params
      params.require(:vehicle_type).permit(:name, :description)
    end
end
