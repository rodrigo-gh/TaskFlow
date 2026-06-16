class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5099',
  );
}

// static const String baseUrl = 'http://192.168.18.84:5099';
