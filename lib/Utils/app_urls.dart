class AppUrls {
  // static const String baseUrl = "http://localhost:4000/api/";
  static const String baseUrl = "https://otobix-app-backend.onrender.com/api/";
  // static const String baseUrl =
  //     "http://192.168.100.99:4000/api/"; // For Mobile Testing

  static final String socketBaseUrl = _extractSocketBaseUrl(
    baseUrl,
  ); // Socket base URL

  static const String sendOtp = "${baseUrl}send-otp";

  static const String verifyOtp = "${baseUrl}verify-otp";

  static const String login = "${baseUrl}user/login";

  static const String register = "${baseUrl}user/register";

  static const String allUsersList = "${baseUrl}user/all-users-list";

  static const String approvedUsersList = "${baseUrl}user/approved-users-list";

  static const String pendingUsersList = "${baseUrl}user/pending-users-list";

  static const String rejectedUsersList = "${baseUrl}user/rejected-users-list";

  static const String usersLength = "${baseUrl}user/users-length";

  static const String updateProfile = "${baseUrl}user/update-profile";

  static const String getUserProfile = "${baseUrl}user/user-profile";

  static String checkUsernameExists(String username) =>
      "${baseUrl}user/check-username?username=$username";

  static String updateUserStatus(String userId) =>
      "${baseUrl}user/update-user-status/$userId";

  static String getUserStatus(String userId) =>
      "${baseUrl}user/user-status/$userId";

  static String logout(String userId) => "${baseUrl}user/logout/$userId";

  static String getCarDetails(String carId) => "${baseUrl}car/details/$carId";

  static String getCarsList({required String auctionStatus}) =>
      "${baseUrl}car/cars-list?auctionStatus=$auctionStatus";

  static String updateUserThroughAdmin(String userId) =>
      "${baseUrl}user/update-user-through-admin/?userId=$userId";

  static const String updateCarBid = "${baseUrl}car/update-bid";

  static const String updateCarAuctionTime =
      "${baseUrl}car/update-auction-time";

  static const String checkHighestBidder = "${baseUrl}car/check-highest-bidder";

  static const String submitAutoBidForLiveSection =
      "${baseUrl}car/submit-auto-bid-for-live-section";

  static const String userNotifications =
      "${baseUrl}user/notifications/create-notification";

  static String userNotificationsList({
    required String userId,
    required int page,
    required int limit,
  }) =>
      "${baseUrl}user/notifications/notifications-list?userId=$userId&page=$page&limit=$limit";

  static String userNotificationsDetail({
    required String userId,
    required String notificationId,
  }) =>
      "${baseUrl}user/notifications/notification-details?userId=$userId&notificationId=$notificationId";

  static const String userNotificationsMarkRead =
      "${baseUrl}user/notifications/mark-notification-as-read";

  static const String userNotificationsMarkAllRead =
      "${baseUrl}user/notifications/mark-all-notifications-as-read";

  static String userNotificationsUnreadNotificationsCount({
    required String userId,
  }) =>
      "${baseUrl}user/notifications/get-unread-notifications-count?userId=$userId";

  static String getUserWishlist({required String userId}) =>
      "${baseUrl}user/get-user-wishlist?userId=$userId";

  static const String addToWishlist = "${baseUrl}user/add-to-wishlist";

  static const String removeFromWishlist =
      "${baseUrl}user/remove-from-wishlist";

  static String getUserWishlistCarsList({required String userId}) =>
      "${baseUrl}user/get-user-wishlist-cars-list?userId=$userId";

  static String getUserMyBidsList({required String userId}) =>
      "${baseUrl}user/get-user-my-bids?userId=$userId";

  static const String addToMyBids = "${baseUrl}user/add-to-my-bids";

  static const String removeFromMyBids = "${baseUrl}user/remove-from-my-bids";

  static String getUserMyBidsCarsList({required String userId}) =>
      "${baseUrl}user/get-user-my-bids-cars-list?userId=$userId";

  // Socket URL Extraction
  static String _extractSocketBaseUrl(String url) {
    final uri = Uri.parse(url);
    return '${uri.scheme}://${uri.host}:${uri.port}';
  }
}
