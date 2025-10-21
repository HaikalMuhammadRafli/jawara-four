import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2172F3);
  static const Color hoverBlue = Color(0xFF1958BB);
  static const Color highlightBlue = Color(0xFF66B2FF);
  
  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFF0F0F0);
  
  // Text Colors
  static const Color primaryText = Color(0xFF1E1E1E);
  static const Color descriptionText = Color(0xFF666666);
  
  // Status Colors
  static const Color success = Color(0xFF22BB44);
  static const Color error = Color(0xFFF34235);
  static const Color prompt = Color(0xFFF39C12);
  
  // Additional Colors
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color mediumGray = Color(0xFFE9ECEF);
  static const Color darkGray = Color(0xFF495057);
  
  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, hoverBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [background, lightGray],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
