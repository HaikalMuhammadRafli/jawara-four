import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Professional Blue Palette
  static const Color primary = Color(0xFF1E88E5); // Material Blue 600
  static const Color primaryDark = Color(0xFF1565C0); // Material Blue 800
  static const Color primaryLight = Color(0xFF42A5F5); // Material Blue 400

  // Secondary Colors
  static const Color secondary = Color(0xFF26A69A); // Material Teal 400
  static const Color secondaryDark = Color(0xFF00897B); // Material Teal 600

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF5F5F5); // Material Grey 100
  static const Color surface = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Material Grey 900
  static const Color textSecondary = Color(0xFF757575); // Material Grey 600
  static const Color textHint = Color(0xFF9E9E9E); // Material Grey 500

  // Status Colors
  static const Color success = Color(0xFF43A047); // Material Green 600
  static const Color successLight = Color(0xFF66BB6A); // Material Green 400
  static const Color error = Color(0xFFE53935); // Material Red 600
  static const Color errorLight = Color(0xFFEF5350); // Material Red 400
  static const Color warning = Color(0xFFFB8C00); // Material Orange 600
  static const Color info = Color(0xFF039BE5); // Material Light Blue 600

  // Border & Divider Colors
  static const Color divider = Color(0xFFE0E0E0); // Material Grey 300
  static const Color border = Color(0xFFBDBDBD); // Material Grey 400

  // Shadow Colors
  static const Color shadow = Color(0x1A000000); // 10% black

  // Gradient Functions (non-const for flexibility)
  static LinearGradient primaryGradient() => const LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient successGradient() => const LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient errorGradient() => const LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
