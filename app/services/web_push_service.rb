class WebPushService
  def self.notify_new_order(fuel_order)
    recipients = get_order_recipients(fuel_order)
    
    recipients.each do |user|
      send_notification(
        user,
        title: "New Fuel Order",
        body: "Order ##{fuel_order.formatted_number} requested by #{fuel_order.requester_assignment.personal.full_name}",
        url: Rails.application.routes.url_helpers.admin_fuel_order_url(fuel_order, host: default_host)
      )
    end
  end

  def self.notify_order_approved(fuel_order)
    requester_user = User.find_by(personal_id: fuel_order.requester_assignment.personal_id)
    return unless requester_user

    send_notification(
      requester_user,
      title: "Order Approved",
      body: "Your order ##{fuel_order.formatted_number} has been approved",
      url: Rails.application.routes.url_helpers.admin_fuel_order_url(fuel_order, host: default_host)
    )
  end

  private

  def self.get_order_recipients(fuel_order)
    users = []
    
    # Admin: receives all orders
    users += User.joins(:role).where(roles: { name: 'Admin' })
    
    # Operation: receives orders where they are requester or approver
    if fuel_order.approver_assignment_id.present?
      approver_user = User.find_by(personal_id: fuel_order.approver_assignment.personal_id)
      users << approver_user if approver_user&.role&.name == 'Operation'
    end
    
    users.uniq
  end

  def self.send_notification(user, title:, body:, url: nil)
    user.push_subscriptions.find_each do |subscription|
      message = {
        title: title,
        body: body,
        url: url || Rails.application.routes.url_helpers.root_url(host: default_host)
      }.to_json

      begin
        WebPush.payload_send(
          message: message,
          endpoint: subscription.endpoint,
          p256dh: subscription.p256dh,
          auth: subscription.auth,
          vapid: {
            subject: "mailto:#{Rails.application.credentials.dig(:web_push, :contact_email) || 'admin@omsfuels.com'}",
            public_key: Rails.application.credentials.dig(:web_push, :vapid_public_key),
            private_key: Rails.application.credentials.dig(:web_push, :vapid_private_key)
          }
        )
      rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription
        subscription.destroy
      rescue => e
        Rails.logger.error "Push notification error: #{e.message}"
      end
    end
  end

  def self.default_host
    Rails.env.production? ? 'omsfuels.com' : 'localhost:3000'
  end
end
