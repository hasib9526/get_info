class ApiConfig {
  // Base URL
  static const String baseUrl = 'http://apps.bitopibd.com:8090/bimobapiv2/api';

  // Authentication Endpoints
  static const String loginEndpoint = '/Account/GetUserInfo';
  static const String refreshTokenEndpoint = '/Auth/RefreshToken';
  static const String logoutEndpoint = '/Auth/Logout';

  // Full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get refreshTokenUrl => '$baseUrl$refreshTokenEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
