class SocketEvents {
  // Built-in
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String connectError = 'connect_error';
  static const String error = 'error';

  // Custom Events (match your backend)
  static const String bidUpdated = 'bid-updated';
  static const String auctionEnded = 'auction-ended';
  static const String wishlistUpdated = 'wishlist-updated';
  static const String myBidsUpdated = 'my-bids-updated';
  static const String liveBidsSectionUpdated = 'live-bids-section-updated';
  static const String userNotificationCreated = 'user-notification-created';
  static const String userNotificationMarkedAsRead =
      'user-notification-marked-as-read';
  static const String userAllNotificationsMarkedAsRead =
      'user-all-notifications-marked-as-read';
  static const String auctionTimerUpdated = 'auction-timer-updated';
  static const String updatedAdminHomeUsers = 'updated-admin-home-users';

  // Rooms
  static const String joinRoom = 'join-room';
  static const String leaveRoom = 'leave-room';
  static const String userRoom = 'user-room:';
  static const String liveBidsSectionRoom = 'live-bids-section-room:';
  static const String userNotificationsRoom = 'user-notifications-room:';
  static const String auctionTimerRoom = 'auction-timer-room:';
  static const String adminHomeRoom = 'admin-home-room:';
}
