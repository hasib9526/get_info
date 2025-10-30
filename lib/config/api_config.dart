class ApiConfig {
  // Base URL
  static const String baseUrl = 'http://apps.bitopibd.com:8090/bimobapiv2/api';

  // Authentication Endpoints
  static const String loginEndpoint = '/Account/GetUserInfo';
  static const String refreshTokenEndpoint = '/Auth/RefreshToken';
  static const String logoutEndpoint = '/Auth/Logout';

  // Employee Endpoints
  static const String getEmployeeEndpoint = '/WorkerSurveyMaster/GetEmployee';
  static const String saveToBISEndpoint = '/WorkerSurveyMaster/ToBIS';
  static const String checkEmployeeExistsEndpoint = '/WorkerSurveyMaster/CheckEmployeeExists';

  // Full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get refreshTokenUrl => '$baseUrl$refreshTokenEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';
  static String get getEmployeeUrl => '$baseUrl$getEmployeeEndpoint';
  static String get saveToBISUrl => '$baseUrl$saveToBISEndpoint';
  static String get checkEmployeeExistsUrl => '$baseUrl$checkEmployeeExistsEndpoint';

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
