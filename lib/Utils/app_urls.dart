class AppUrls {
  // static const String baseUrl = "http://localhost:4000/api/";
  static const String baseUrl = "https://otobix-app-backend.onrender.com/api/";

  static const String sendOtp = "${baseUrl}send-otp";

  static const String verifyOtp = "${baseUrl}verify-otp";

  static const String login = "${baseUrl}user/login";

  static const String logout = "${baseUrl}user/logout";

  static const String register = "${baseUrl}user/register";

  static const String allUsers = "${baseUrl}user/all-users";
  
  static const String userProfile = "${baseUrl}user/user-profile";
  
  static const String updateProfile = "${baseUrl}user/update-profile";

  static String checkUsernameExists(String username) =>
      "${baseUrl}user/check-username?username=$username";


}
