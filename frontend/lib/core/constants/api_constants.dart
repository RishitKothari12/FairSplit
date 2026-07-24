class ApiConstants {
  ApiConstants._();

  // Android Emulator
  static const String baseUrl = "http://192.168.1.12:8000";

  // Uncomment if running on physical device
  // static const String baseUrl = "http://YOUR_LOCAL_IP:8000";

  static const String login = "/auth/login";
  static const String register = "/auth/register";

  static const String groups = "/groups";
  static const String expenses = "/expenses";
  static const String balances = "/balances";
  static const String settlements = "/settlements";
  static const users = "/users";
}