import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _inited = false;

  /// 1) Init OneSignal with your App ID and ask for permission
  Future<void> init(String appId) async {
    if (_inited) return;

    OneSignal.initialize(appId); // start SDK
    await OneSignal.Notifications.requestPermission(true); // show OS prompt

    // When a notification arrives in foreground: just show it
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // Only call this if you want to stop the default auto-display:
      event.preventDefault();

      // v5: display the SAME notification object
      event.notification.display();
    });

    // When the user taps a notification
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData ?? {};
      // TODO: print or navigate based on your payload
      // e.g., print('Tapped notif. data = $data');
    });

    _inited = true;
  }

  /// 2) Link this device to YOUR user id (so server can target them)
  Future<void> login(String externalUserId) async {
    await OneSignal.login(externalUserId);
  }

  /// 3) unlink the device from the current user (call on sign-out)
  Future<void> logout() async {
    await OneSignal.logout();
  }
}
