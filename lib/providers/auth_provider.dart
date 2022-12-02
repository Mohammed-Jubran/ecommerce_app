import 'dart:convert';
import 'package:ecommerce_app/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  String errorMsg = '';
  late String otpCode;

  Future<bool> login(String phone, String password) async {
    final response = await http.post(Uri.parse('${Constants.URL}login.php'),
        body: {'Phone': phone, 'Password': password});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      if (jsonBody['result']) {
        _prefs = await SharedPreferences.getInstance();
        _prefs.setString(Constants.ID, jsonBody['Id']);
        _prefs.setString(Constants.EMAIL, jsonBody['Email']);
        _prefs.setString(Constants.PHONE, jsonBody['Phone']);
        _prefs.setString(Constants.USERNAME, jsonBody['UserName']);
      }
      return jsonBody['result'];
    }
    notifyListeners();
    return false;
  }

  Future<bool> signUp(
      {required String email,
      required String username,
      required String phone,
      required String password}) async {
    final response = await http.post(Uri.parse('${Constants.URL}SignUp.php'),
        body: {
          'Email': email,
          'UserName': username,
          'Phone': phone,
          'Password': password
        });
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      if (jsonBody['result']) {
        _prefs = await SharedPreferences.getInstance();
        _prefs.setString(Constants.ID, jsonBody['Id']);
        _prefs.setString(Constants.EMAIL, jsonBody['Email']);
        _prefs.setString(Constants.PHONE, jsonBody['Phone']);
        _prefs.setString(Constants.USERNAME, jsonBody['UserName']);
      } else {
        errorMsg = jsonBody['msg'];
      }
      return jsonBody['result'];
    }
    notifyListeners();
    return false;
  }

  sendOtp(String phone) async {
    final response = await http
        .post(Uri.parse('${Constants.URL}otp.php'), body: {'Phone': phone});
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      if (jsonBody['result']) {
        otpCode = jsonBody['code'];
        print(otpCode);
      }
    }
    notifyListeners();
  }
}
