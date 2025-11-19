/// API configuration
library;

class ApiConfig {
  /// Base URL for the backend API
  /// For iOS simulator: http://localhost:8000
  /// For Android emulator: http://10.0.2.2:8000
  /// For physical device: http://<your-machine-ip>:8000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );

  /// API version prefix
  static const String apiPrefix = '/api/v1';

  /// Full API URL
  static String get apiUrl => '$baseUrl$apiPrefix';

  /// Request timeout in seconds
  static const Duration timeout = Duration(seconds: 30);

  /// Enable logging for debugging
  static const bool enableLogging = true;
}
