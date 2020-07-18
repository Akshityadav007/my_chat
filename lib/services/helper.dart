import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferencePhoneNumber = "PHONENUMBERKEY";
  static String sharedPreferenceLoggedIn = "ISLOGGEDINKEY";

  // saving data to SharedPreference

  static Future<bool> savePhoneNumberSharedPreference(String userPhoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencePhoneNumber,userPhoneNumber);
  }

  static Future<bool> saveUserLoggedInPreference(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceLoggedIn, isUserLoggedIn);
  }


  static Future<String> getPhoneNumberSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencePhoneNumber);
  }

  static Future<bool> getUserLoggedInPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceLoggedIn);
  }

  //clear all sharedPreferencesData


static Future<bool> removeSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
}
}