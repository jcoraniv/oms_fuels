# Web Push Notifications - Setup

## Completed Implementation

A web push notification system has been implemented for OMS Fuels with the following features:

### Features

1. **Notifications for Admin and Operation**:
   - Admin receives notifications for ALL fuel orders created
   - Operation receives notifications only for orders where they are the approver

2. **Notifications for Employee**:
   - Receives notification when their order is approved

### Files created/modified

- `app/models/push_subscription.rb` - Model for subscriptions
- `app/controllers/push_subscriptions_controller.rb` - Controller to handle subscriptions
- `app/services/web_push_service.rb` - Service to send notifications
- `app/javascript/push_notifications.js` - JavaScript client
- `public/service-worker.js` - Service Worker
- `app/views/push_subscriptions/_notification_button.html.erb` - UI button
- Database migration for `push_subscriptions`

### Required Configuration

**IMPORTANT**: VAPID keys must be generated using the WebPush library, not random strings.

#### For Development/Testing:

You can use the provided example keys or generate new ones.

#### For Production:

1. **Generate VAPID keys** (REQUIRED for production):

```bash
bundle exec ruby lib/tasks/generate_vapid_keys.rb
```

This will output something like:
```
=== VAPID Keys Generated ===
vapid_public_key: BKafHNHu9dbTUQpAORDaN6wWC0C283vS5Dz_6e_sloiXE05W-eckX6RtQbOcuI1zmmLqC8wNExsy_j7qRvIZyxA=
vapid_private_key: wXXzYakaSdIMqk-XHEKmRi7YCh3vAWCIr6Vzf_SPrGo=
```

2. **Add keys to production credentials**:

```bash
EDITOR="nano" rails credentials:edit --environment production
```

Add:
```yaml
web_push:
  vapid_public_key: <paste_generated_public_key>
  vapid_private_key: <paste_generated_private_key>
  contact_email: admin@omsfuels.com  # Single contact email for the entire application
```

**Note**: `contact_email` is a single email for the entire application (not per user). Push services use it to contact you about technical issues or abuse reports.

3. **NEVER reuse keys between environments** - Generate separate keys for development, staging, and production.

### Usage

1. Users will see an "Enable Notifications" button in the navbar
2. When clicked, browser permission will be requested
3. Once enabled, they will receive notifications according to their role:
   - **Admin**: All new orders
   - **Operation**: Orders where they are the approver
   - **Employee**: When their order is approved

### Important Notes

- Notifications require HTTPS in production
- Service worker must be at `/service-worker.js`
- Users must give explicit permission to receive notifications
- Expired subscriptions are automatically removed

### Testing

To test locally:
1. Use `localhost` (works without HTTPS)
2. Enable notifications from the button
3. **macOS users**: Verify Chrome has notification permissions in System Preferences → Notifications
4. Create a fuel order
5. Verify that Admin/Operation receive the notification
6. Approve the order
7. Verify that the Employee receives the notification

### Troubleshooting

- **Notifications not appearing on macOS**: Check System Preferences → Notifications → Chrome and ensure notifications are enabled
- **Service Worker not registering**: Check browser console for errors
- **Permission denied**: User must explicitly allow notifications when prompted

test