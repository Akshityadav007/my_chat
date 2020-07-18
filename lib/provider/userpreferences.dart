import 'package:flutter/material.dart';
import 'package:mychat/services/helper.dart';

class UserPrefs with ChangeNotifier {
  String _phoneNumber = "";

  UserPrefs() {
    init();
  }

  init() async {
    _phoneNumber = await HelperFunctions.getPhoneNumberSharedPreference();
    notifyListeners();
  }

  String get getPhoneNumber => _phoneNumber;
}