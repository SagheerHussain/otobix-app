import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otobix/Utils/app_constants.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _inited = false;

  /// 1) Init OneSignal with your App ID and ask for permission
  Future<void> init() async {
    if (_inited) return;

    OneSignal.initialize(AppConstants.oneSignalAppId); // start SDK
    await OneSignal.Notifications.requestPermission(true); // show OS prompt

    // When a notification arrives in foreground: just show it
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      // final n = event.notification;
      // final reqId = n.additionalData?['requestId'];
      // final ext = n.additionalData?['ext']; // "dev:<mongoId>"
      // final env = n.additionalData?['env']; // "dev" | "prod"

      // // Simple log (replace with your logger/analytics)
      // debugPrint(
      //   '[PushFG] id=${n.notificationId} requestId=$reqId env=$env ext=$ext title=${n.title}',
      // );

      // Only call this if you want to stop the default auto-display:
      event.preventDefault();

      // v5: display the SAME notification object
      event.notification.display();
    });

    // When the user taps a notification
    OneSignal.Notifications.addClickListener((event) {
      // final n = event.notification;
      // final reqId = n.additionalData?['requestId'];
      // final ext = n.additionalData?['ext'];
      // final env = n.additionalData?['env'];

      // debugPrint(
      //   '[PushClick] id=${n.notificationId} requestId=$reqId env=$env ext=$ext data=${n.additionalData}',
      // );

      //

      final data = event.notification.additionalData ?? {};
      // TODO: print or navigate based on your payload
      // e.g., print('Tapped notif. data = $data');
    });

    _inited = true;
  }

  /// 2) Link this device to YOUR user id (so server can target them)
  Future<void> login(String mongoUserId) async {
    final externalUserId = AppConstants.externalIdForNotifications(
      mongoUserId,
    ); // "dev:<id>" or "prod:<id>"
    await OneSignal.login(externalUserId);
    await OneSignal.User.addTagWithKey(
      "env",
      AppConstants.envName,
    ); // "dev"|"prod"
  }

  /// 3) unlink the device from the current user (call on sign-out)
  Future<void> logout() async {
    await OneSignal.logout();
  }
}
