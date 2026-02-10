class PushNotifications {
  constructor() {
    this.publicKey = null;
    this.init();
  }

  async init() {
    if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
      console.log('Push notifications not supported');
      return;
    }

    try {
      const registration = await navigator.serviceWorker.register('/service-worker.js');
      console.log('Service Worker registered');
      
      const response = await fetch('/push_subscriptions/vapid_public_key');
      const data = await response.json();
      this.publicKey = data.publicKey;
    } catch (error) {
      console.error('Service Worker registration failed:', error);
    }
  }

  async subscribe() {
    try {
      const registration = await navigator.serviceWorker.ready;
      const permission = await Notification.requestPermission();
      
      if (permission !== 'granted') {
        console.log('Notification permission denied');
        return;
      }

      const subscription = await registration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: this.urlBase64ToUint8Array(this.publicKey)
      });

      await this.sendSubscriptionToServer(subscription);
      console.log('Push subscription successful');
    } catch (error) {
      console.error('Push subscription failed:', error);
    }
  }

  async unsubscribe() {
    try {
      const registration = await navigator.serviceWorker.ready;
      const subscription = await registration.pushManager.getSubscription();
      
      if (subscription) {
        await subscription.unsubscribe();
        await this.removeSubscriptionFromServer(subscription);
        console.log('Push unsubscription successful');
      }
    } catch (error) {
      console.error('Push unsubscription failed:', error);
    }
  }

  async sendSubscriptionToServer(subscription) {
    const key = subscription.getKey('p256dh');
    const token = subscription.getKey('auth');
    
    const response = await fetch('/push_subscriptions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        subscription: {
          endpoint: subscription.endpoint,
          p256dh: this.arrayBufferToBase64(key),
          auth: this.arrayBufferToBase64(token)
        }
      })
    });

    if (!response.ok) {
      throw new Error('Failed to send subscription to server');
    }
  }

  async removeSubscriptionFromServer(subscription) {
    await fetch(`/push_subscriptions/${encodeURIComponent(subscription.endpoint)}`, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      }
    });
  }

  urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4);
    const base64 = (base64String + padding).replace(/\-/g, '+').replace(/_/g, '/');
    const rawData = window.atob(base64);
    const outputArray = new Uint8Array(rawData.length);
    for (let i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i);
    }
    return outputArray;
  }

  arrayBufferToBase64(buffer) {
    const bytes = new Uint8Array(buffer);
    let binary = '';
    for (let i = 0; i < bytes.byteLength; i++) {
      binary += String.fromCharCode(bytes[i]);
    }
    return window.btoa(binary);
  }
}

window.pushNotifications = new PushNotifications();
