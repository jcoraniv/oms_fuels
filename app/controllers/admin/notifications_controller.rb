class Admin::NotificationsController < Admin::BaseController
  def mark_read
    notification_type = params[:type]
    gestion = current_user.current_gestion
    
    notification_read = NotificationRead.find_or_initialize_by(
      user: current_user,
      gestion: gestion,
      notification_type: notification_type
    )
    notification_read.read_at = Time.current
    notification_read.save

    status_map = {
      'requested_orders' => 'pending',
      'approved_orders' => 'approved',
      'rejected_orders' => 'canceled'
    }

    redirect_to admin_fuel_orders_path(status: status_map[notification_type])
  end
end
