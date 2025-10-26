import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class ApiService {
  Future<LoginResponse?> login({
    required String userName,
    required String password,
  }) async {
    try {
      // Create login request
      final loginRequest = LoginRequest(
        userName: userName,
        password: password,
      );

      // Build URL with query parameters
      final uri = Uri.parse(ApiConfig.loginUrl)
          .replace(queryParameters: loginRequest.toQueryParameters());

      print('🔐 API Request: $uri');

      // Make GET request
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(ApiConfig.connectionTimeout);

      print('🔐 API Response Status: ${response.statusCode}');
      print('🔐 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Parse the response
        final loginResponse = LoginResponse.fromJson(jsonData);

        // Check if essential fields are null or empty - indicates invalid credentials
        if (loginResponse.userCode == null ||
            loginResponse.userName == null ||
            loginResponse.userCode!.trim().isEmpty ||
            loginResponse.userName!.trim().isEmpty) {
          print('❌ API: Invalid credentials - essential fields are null/empty');
          throw Exception('Invalid username or password');
        }

        print('✅ API: Login successful');
        return loginResponse;
      } else {
        print('❌ API: Login failed - Status: ${response.statusCode}');
        throw Exception('Login failed. Please check your credentials.');
      }
    } catch (e) {
      print('❌ API Error: $e');
      if (e.toString().contains('Invalid username or password')) {
        rethrow;
      }
      throw Exception('Network error. Please check your connection.');
    }
  }
}
