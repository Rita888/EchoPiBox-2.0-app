import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:batsexplorer/utils/constants.dart';

class AppState {
  static String userId="",
      firstname="",
      lastname="",
      fullname="",
      email="";
  static bool isLogin = false;
  static double currentLocationLatitude=51.544870;
  static double currentLocationLongitude=-0.017147612;
  static EventBus eventBus = EventBus();

  static Future synchronizeSettingsFromPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(Constants.USERID) ?? '';
    firstname = prefs.getString(Constants.FIRSTNAME) ?? '';
    lastname = prefs.getString(Constants.LASTNAME) ?? '';
    email = prefs.getString(Constants.EMAIL) ?? '';
    isLogin = prefs.getBool(Constants.ISLOGIN) ?? false;

  }

  static Future synchronizeSettingsToPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(Constants.USERID, userId);
    await prefs.setString(Constants.FIRSTNAME, firstname);
    await prefs.setString(Constants.LASTNAME, lastname);
    await prefs.setString(Constants.FULLNAME, fullname);
    await prefs.setString(Constants.EMAIL, email);
    await prefs.setBool(Constants.ISLOGIN, isLogin);
  }

  static Future logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
