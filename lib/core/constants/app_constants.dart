class AppConstants {
  // API
  static const String baseUrl = 'https://dummyjson.com';
  static const String loginEndpoint = '/auth/login';
  static const String productsEndpoint = '/products';
  static const String postsEndpoint = '/posts';

  // Pagination
  static const int pageLimit = 10;

  // SharedPreferences Keys
  static const String keyUser = 'cached_user';
  static const String keyTheme = 'theme_mode';
  static const String keyToken = 'auth_token';

  // Login credentials (for DummyJSON demo)
  static const String demoUsername = 'emilys';
  static const String demoPassword = 'emilyspass';
}
