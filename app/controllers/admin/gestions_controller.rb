class Admin::GestionsController < Admin::BaseController
  before_action :set_gestion, only: [:show, :edit, :update, :destroy]

  def index
    @gestions = Gestion.all
  end

  def show
  end

  def new
    @gestion = Gestion.new
  end

  def create
    @gestion = Gestion.new(gestion_params)
    if @gestion.save
      redirect_to admin_gestions_path, notice: 'Gestion was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gestion.update(gestion_params)
      redirect_to admin_gestions_path, notice: 'Gestion was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gestion.destroy
    redirect_to admin_gestions_path, notice: 'Gestion was successfully destroyed.'
  end

  private

  def set_gestion
    @gestion = Gestion.find(params[:id])
  end

  def gestion_params
    params.require(:gestion).permit(:code, :name, :active)
  end
end
