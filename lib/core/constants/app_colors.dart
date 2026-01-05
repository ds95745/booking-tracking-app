import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Status Colors
  static const Color statusPending = Color(0xFFFF9800);
  static const Color statusAccepted = Color(0xFF2196F3);
  static const Color statusOnTheWay = Color(0xFF9C27B0);
  static const Color statusCompleted = Color(0xFF4CAF50);

  // UI Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderMedium = Color(0xFFBDBDBD);

  // Helper method to get status color
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return statusPending;
      case 'Accepted':
        return statusAccepted;
      case 'On The Way':
        return statusOnTheWay;
      case 'Completed':
        return statusCompleted;
      default:
        return textSecondary;
    }
  }
}

