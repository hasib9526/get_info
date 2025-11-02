import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Base URL
  // Original API (for mobile/local development)
  static const String _originalBaseUrl = 'http://apps.bitopibd.com:8090/bimobapiv2/api';

  // CORS Proxy for web deployment (temporary solution)
  // WARNING: Only use for testing! Not secure for production!
  static const String _corsProxyUrl = 'https://corsproxy.io/?';

  // Determine which URL to use based on platform
  static String get baseUrl {
    // For web builds, use CORS proxy (temporary fix)
    // For mobile/desktop, use original URL
    if (kIsWeb) {
      return '$_corsProxyUrl$_originalBaseUrl';
    }
    return _originalBaseUrl;
  }

  // Authentication Endpoints
  static const String loginEndpoint = '/Account/GetUserInfo';
  static const String refreshTokenEndpoint = '/Auth/RefreshToken';
  static const String logoutEndpoint = '/Auth/Logout';

  // Employee Endpoints
  static const String getEmployeeEndpoint = '/WorkerSurveyMaster/GetEmployee';
  static const String saveToBISEndpoint = '/WorkerSurveyMaster/ToBIS';
  static const String getEmpEndpoint = '/WorkerSurveyMaster/GetEmp';

  // Full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get refreshTokenUrl => '$baseUrl$refreshTokenEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';
  static String get getEmployeeUrl => '$baseUrl$getEmployeeEndpoint';
  static String get saveToBISUrl => '$baseUrl$saveToBISEndpoint';
  static String get getEmpUrl => '$baseUrl$getEmpEndpoint';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Company to Factory code mapping
  static const Map<String, String> companyFactoryMap = {
    'TAL': '06',
    'RHL': '09',
    'BGL': '04',
    'MGL': '02',
  };

  // Helper method to get factory code from company
  static String getFactoryCode(String company) {
    return companyFactoryMap[company] ?? '00';
  }
}
