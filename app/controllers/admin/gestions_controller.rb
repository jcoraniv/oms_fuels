class Admin::GestionsController < Admin::BaseController
  include SoftDeletableController
  
  before_action :set_gestion, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create]

  def index
    @q = Gestion.not_deleted.ransack(params[:q])
    @gestions = @q.result.page(params[:page])
  end

  def show
  end

  def new
    @gestion = Gestion.new
  end

  def create
    @gestion = Gestion.new(gestion_params)
    if @gestion.save
      redirect_to admin_gestions_path, notice: t('common.messages.gestion_created')
    else
      flash.now[:error] = @gestion.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gestion.update(gestion_params)
      redirect_to admin_gestions_path, notice: t('common.messages.gestion_updated')
    else
      flash.now[:error] = @gestion.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    destroy_with_soft_delete(@gestion, admin_gestions_path, 'Gestion')
  end

  private

  def set_gestion
    @gestion = Gestion.find(params[:id])
  end

  def gestion_params
    params.require(:gestion).permit(:code, :name, :active)
  end

  def require_admin
    redirect_to admin_gestions_path, alert: t('common.messages.access_denied') unless current_user.admin?
  end
end
