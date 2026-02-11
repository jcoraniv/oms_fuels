class Admin::FuelsController < Admin::BaseController
  include SoftDeletableController
  
  before_action :set_fuel, only: [:show, :edit, :update, :destroy]

  def index
    @fuels = Fuel.not_deleted.all
  end

  def show
  end

  def new
    @fuel = Fuel.new
  end

  def edit
  end

  def create
    @fuel = Fuel.new(fuel_params)

    if @fuel.save
      redirect_to admin_fuel_path(@fuel), notice: t('common.created', model: 'Fuel')
    else
      render :new
    end
  end

  def update
    if @fuel.update(fuel_params)
      redirect_to admin_fuel_path(@fuel), notice: t('common.updated', model: 'Fuel')
    else
      render :edit
    end
  end

  def destroy
    destroy_with_soft_delete(@fuel, admin_fuels_url, 'Fuel')
  end

  private
    def set_fuel
      @fuel = Fuel.find(params[:id])
    end

    def fuel_params
      params.require(:fuel).permit(:description, :unit_of_measure, :reference_price)
    end
end
