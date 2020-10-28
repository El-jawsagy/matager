import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isArabic = prefs.getString('lang');
    return isArabic;
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("token");
    return datId;
  }

  static Future<double> getLat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("lat");
    return datId;
  }

  static Future<double> getLng() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("lng");
    return datId;
  }

  static Future<String> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("address");
    return datId;
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.get("name");
    return name;
  }

  static Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.get("UserId");
    return userId;
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.get("email");
    return email;
  }
}
