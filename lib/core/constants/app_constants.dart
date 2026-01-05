class AppConstants {
  // App Info
  static const String appName = 'Booking & Tracking App';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyBookings = 'bookings';

  // API Constants (Mock)
  static const String baseUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Google Maps
  static const double defaultZoom = 15.0;
  static const double defaultLatitude = 37.7749; // San Francisco
  static const double defaultLongitude = -122.4194;

  // Booking Status
  static const String statusPending = 'Pending';
  static const String statusAccepted = 'Accepted';
  static const String statusOnTheWay = 'On The Way';
  static const String statusCompleted = 'Completed';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

