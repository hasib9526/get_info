import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response.dart';

class SessionService {
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> saveUserSession(LoginResponse userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = jsonEncode(userData.toJson());
    await prefs.setString(_userDataKey, userDataJson);
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<LoginResponse?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString(_userDataKey);

    if (userDataJson != null) {
      final userDataMap = jsonDecode(userDataJson) as Map<String, dynamic>;
      return LoginResponse.fromJson(userDataMap);
    }

    return null;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<String?> getUserCode() async {
    final userData = await getUserData();
    return userData?.userCode ?? '';
  }

  Future<String?> getUserName() async {
    final userData = await getUserData();
    return userData?.userName;
  }

  Future<String?> getEmployeeName() async {
    final userData = await getUserData();
    return userData?.employeeName ?? '';
  }

  Future<String?> getEmail() async {
    final userData = await getUserData();
    return userData?.email ?? '';
  }

  Future<String?> getDepartment() async {
    final userData = await getUserData();
    return userData?.department ?? '';
  }

  Future<String?> getDesignation() async {
    final userData = await getUserData();
    return userData?.designation ?? '';
  }
}
