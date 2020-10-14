import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationUtility {
  static String accessToken;

  static Future<String> getMyJwt() async {
    if (accessToken == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('access');
    }
    return accessToken;
  }
}
