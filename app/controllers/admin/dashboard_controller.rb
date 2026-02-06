class Admin::DashboardController < Admin::BaseController
  def index
    @orders_by_status = calculate_orders_by_status
  end

  private

  def calculate_orders_by_status
    gestion = current_user.current_gestion

    base_scope = if current_user.admin?
                   FuelOrder.where(gestion: gestion)
                 elsif current_user.operation?
                   assignment = current_user.personal.assignments.current
                                            .joins(org_position: :org_structure)
                                            .find_by(org_structures: { gestion_id: gestion.id })

                   FuelOrder.where(gestion: gestion)
                            .where("requester_assignment_id = ? OR approver_assignment_id = ?", assignment&.id, assignment&.id)
                 else
                   # employee
                   assignment = current_user.personal.assignments.current
                                            .joins(org_position: :org_structure)
                                            .find_by(org_structures: { gestion_id: gestion.id })
                   FuelOrder.where(gestion: gestion, requester_assignment_id: assignment&.id)
                 end

    {
      pending: base_scope.pending.count,
      approved: base_scope.approved.count,
      completed: base_scope.completed.count,
      canceled: base_scope.canceled.count
    }
  end
end