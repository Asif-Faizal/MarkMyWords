class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:8080/api';
  static const String wsUrl = 'ws://localhost:8080/ws';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Timeouts
  static const int connectionTimeout = 5000;
  static const int receiveTimeout = 3000;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
}
