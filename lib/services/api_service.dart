import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/employee_model.dart';

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

  // Get Employee Name by Employee ID and Factory code
  Future<String?> getEmployee({
    required String employeeId,
    required String factory,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.getEmployeeUrl);

      print('👤 API Request: GetEmployee - EmployeeID: $employeeId, Factory: $factory');

      // Make POST request
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'EmployeeID': employeeId,
          'Factory': factory,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      print('👤 API Response Status: ${response.statusCode}');
      print('👤 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Response is just a string with the employee name
        final employeeName = json.decode(response.body) as String;
        print('✅ API: Employee name retrieved: $employeeName');
        return employeeName;
      } else {
        print('❌ API: GetEmployee failed - Status: ${response.statusCode}');
        throw Exception('Failed to fetch employee information');
      }
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Network error. Please check your connection.');
    }
  }

  // Save Employee Data to BIS
  Future<bool> saveToBIS({
    required EmployeeModel employee,
    required String addedBy,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.saveToBISUrl);

      // Get current date in ISO format
      final dateAdded = DateTime.now().toIso8601String();

      // Convert employee to API format
      final apiData = employee.toApiJson(
        addedBy: addedBy,
        dateAdded: dateAdded,
      );

      print('💾 API Request: ToBIS');
      print('💾 API Data: ${json.encode(apiData)}');

      // Make POST request
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(apiData),
      ).timeout(ApiConfig.connectionTimeout);

      print('💾 API Response Status: ${response.statusCode}');
      print('💾 API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ API: Employee data saved successfully');
        return true;
      } else {
        print('❌ API: ToBIS failed - Status: ${response.statusCode}');
        throw Exception('Failed to save employee data');
      }
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Network error. Please check your connection.');
    }
  }
}
