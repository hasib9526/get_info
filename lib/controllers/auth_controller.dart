import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/session_service.dart';
import '../services/api_service.dart';
import '../models/login_response.dart';

class AuthController extends GetxController {
  final SessionService _sessionService = SessionService();
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final isAuthenticated = false.obs;
  final Rx<LoginResponse?> userData = Rx<LoginResponse?>(null);
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final loggedIn = await _sessionService.isLoggedIn();
    final user = await _sessionService.getUserData();

    if (loggedIn && user != null) {
      userData.value = user;
      isAuthenticated.value = true;
    }
  }

  Future<bool> login({
    required String userName,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Call real API
      final loginResponse = await _apiService.login(
        userName: userName,
        password: password,
      );

      if (loginResponse != null) {
        // Save session
        await _sessionService.saveUserSession(loginResponse);
        userData.value = loginResponse;
        isAuthenticated.value = true;
        isLoading.value = false;

        return true;
      } else {
        throw Exception('Login failed. Please try again.');
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      isLoading.value = false;
      isAuthenticated.value = false;

      return false;
    }
  }

  Future<void> logout() async {
    await _sessionService.clearSession();
    userData.value = null;
    isAuthenticated.value = false;
    errorMessage.value = '';
  }

  String get displayName => userData.value?.employeeName ?? 'User';
  String get displayEmail => userData.value?.email ?? '';
  String get displayDesignation => userData.value?.designation ?? '';
  String get displayDepartment => userData.value?.department ?? '';
  String get displayUnit => userData.value?.unit ?? '';
}
