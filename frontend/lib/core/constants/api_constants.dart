class ApiConstants {
  ApiConstants._();

  // Android Emulator
static const String baseUrl =
    "https://fairsplit-backend-4i8h.onrender.com"; 

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