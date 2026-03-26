import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0D1B2A); // Deep Navy
  static const Color accent = Color(0xFFFFB627);  // Amber Gold
  static const Color mint = Color(0xFF4ECDC4);    // Mint Teal
  static const Color coral = Color(0xFFFF6B6B);   // Coral Red
  static const Color lavender = Color(0xFF9B5DE5); // Lavender
  
  static const Color surface = Color(0xFFF8F9FF); // Soft White
  static const Color cardBG = Colors.white;
  static const Color textDark = Color(0xFF0D1B2A);
  static const Color textMid = Color(0xFF4A5568);
  static const Color textLight = Color(0xFF718096);
  
  static const LinearGradient meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D1B2A),
      Color(0xFF1B263B),
      Color(0xFF415A77),
    ],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF), // white10
      Color(0x0DFFFFFF), // white05 equivalent
    ],
  );

  static const List<Color> riasecColors = [
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF9B5DE5),
    Color(0xFFFFB627),
    Color(0xFFFF8E3C),
    Color(0xFF90A4AE),
  ];
}
