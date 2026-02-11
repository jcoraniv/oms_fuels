module SoftDeletableController
  extend ActiveSupport::Concern

  def destroy_with_soft_delete(resource, redirect_path, model_name)
    if resource.can_hard_delete?
      resource.destroy
      redirect_to redirect_path, notice: t('common.destroyed', model: model_name)
    else
      resource.soft_delete
      redirect_to redirect_path, notice: t('common.soft_deleted', model: model_name)
    end
  end
end
