class AppUrls {
  // static const String baseUrl = "http://localhost:4000/api/";
  static const String baseUrl = "https://otobix-app-backend.onrender.com/api/";
  // static const String baseUrl =
  //     "http://192.168.100.180:4000/api/"; // For Mobile Testing

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

  static const String getCarsList = "${baseUrl}car/cars-list";
}
