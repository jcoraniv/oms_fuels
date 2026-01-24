class Admin::ProfessionsController < Admin::BaseController
  before_action :set_profession, only: [:show, :edit, :update, :destroy]

  def index
    @professions = Profession.all
  end

  def show
  end

  def new
    @profession = Profession.new
  end

  def create
    @profession = Profession.new(profession_params)
    if @profession.save
      redirect_to admin_professions_path, notice: 'Profession was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @profession.update(profession_params)
      redirect_to admin_professions_path, notice: 'Profession was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @profession.destroy
    redirect_to admin_professions_path, notice: 'Profession was successfully destroyed.'
  end

  private

  def set_profession
    @profession = Profession.find(params[:id])
  end

  def profession_params
    params.require(:profession).permit(:name)
  end
end
