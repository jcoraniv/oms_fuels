class FuelOrderPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    admin? || owns_order? || can_approve?
  end

  def create?
    true
  end

  def update?
    admin? || (owns_order? && record.pending?)
  end

  def destroy?
    admin? || (owns_order? && record.pending?)
  end

  def approve?
    admin? || (operations? && can_approve?)
  end

  def complete?
    admin? || operations?
  end

  def cancel?
    admin? || operations?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if admin?
        scope.where(gestion_id: user.current_gestion&.id)
      elsif operations?
        scope.where(gestion_id: user.current_gestion&.id)
             .where("requester_assignment_id IN (?) OR approver_assignment_id IN (?)", 
                    user_assignment_ids, user_assignment_ids)
      else
        scope.where(gestion_id: user.current_gestion&.id, requester_assignment_id: user_assignment_ids)
      end
    end

    private

    def admin?
      user.role.name == 'Admin'
    end

    def operations?
      user.role.name == 'Operations'
    end

    def user_assignment_ids
      user.personal.assignments.pluck(:id)
    end
  end

  private

  def admin?
    user.role.name == 'Admin'
  end

  def operations?
    user.role.name == 'Operations'
  end

  def owns_order?
    user.personal.assignments.pluck(:id).include?(record.requester_assignment_id)
  end

  def can_approve?
    user.personal.assignments.pluck(:id).include?(record.approver_assignment_id)
  end
end
