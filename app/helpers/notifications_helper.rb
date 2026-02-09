module NotificationsHelper
  NOTIFICATION_TYPES = {
    pending: 'requested_orders',
    approved: 'approved_orders',
    canceled: 'rejected_orders'
  }.freeze

  def notifications_for_user(user)
    gestion = user.current_gestion
    return [] unless gestion

    notifications = []
    assignment_ids = user.personal.assignments
                         .joins(org_position: :org_structure)
                         .where(org_structures: { gestion_id: gestion.id })
                         .pluck(:id)

    if user.admin?
      read_record = user.notification_reads.find_by(gestion: gestion, notification_type: NOTIFICATION_TYPES[:pending])
      last_read_at = read_record&.read_at || Time.at(0)
      requested_count = FuelOrder.where(gestion: gestion, status: :pending)
                                  .where('created_at > ?', last_read_at).count
      
      notifications << {
        title: 'New Requested Orders',
        count: requested_count,
        icon: 'bi-file-earmark-text',
        url: admin_mark_read_notifications_path(type: NOTIFICATION_TYPES[:pending]),
        type: NOTIFICATION_TYPES[:pending]
      } if requested_count > 0
    elsif user.operation?
      read_record = user.notification_reads.find_by(gestion: gestion, notification_type: NOTIFICATION_TYPES[:pending])
      last_read_at = read_record&.read_at || Time.at(0)
      requested_count = FuelOrder.where(gestion: gestion, status: :pending, approver_assignment_id: assignment_ids)
                                  .where('created_at > ?', last_read_at).count
      
      notifications << {
        title: 'New Requested Orders',
        count: requested_count,
        icon: 'bi-file-earmark-text',
        url: admin_mark_read_notifications_path(type: NOTIFICATION_TYPES[:pending]),
        type: NOTIFICATION_TYPES[:pending]
      } if requested_count > 0
    end

    if user.admin?
      approved_orders = FuelOrder.where(gestion: gestion, status: :approved)
    elsif user.operation?
      approved_orders = FuelOrder.where(gestion: gestion, status: :approved, requester_assignment_id: assignment_ids)
    else
      approved_orders = FuelOrder.where(gestion: gestion, status: :approved, requester_assignment_id: assignment_ids)
    end
    
    read_record = user.notification_reads.find_by(gestion: gestion, notification_type: NOTIFICATION_TYPES[:approved])
    last_read_at = read_record&.read_at || Time.at(0)
    approved_count = approved_orders.where('approved_at > ?', last_read_at).count
    
    notifications << {
      title: 'New Approved Orders',
      count: approved_count,
      icon: 'bi-check-circle',
      url: admin_mark_read_notifications_path(type: NOTIFICATION_TYPES[:approved]),
      type: NOTIFICATION_TYPES[:approved]
    } if approved_count > 0

    if user.admin?
      canceled_orders = FuelOrder.where(gestion: gestion, status: :canceled)
    elsif user.operation?
      canceled_orders = FuelOrder.where(gestion: gestion, status: :canceled, requester_assignment_id: assignment_ids)
    else
      canceled_orders = FuelOrder.where(gestion: gestion, status: :canceled, requester_assignment_id: assignment_ids)
    end
    
    read_record = user.notification_reads.find_by(gestion: gestion, notification_type: NOTIFICATION_TYPES[:canceled])
    last_read_at = read_record&.read_at || Time.at(0)
    canceled_count = canceled_orders.where('canceled_at > ?', last_read_at).count
    
    notifications << {
      title: 'New Rejected Orders',
      count: canceled_count,
      icon: 'bi-x-circle',
      url: admin_mark_read_notifications_path(type: NOTIFICATION_TYPES[:canceled]),
      type: NOTIFICATION_TYPES[:canceled]
    } if canceled_count > 0

    notifications
  end

  def total_notifications_count(user)
    notifications_for_user(user).sum { |n| n[:count] }
  end
end
