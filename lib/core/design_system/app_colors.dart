import 'package:flutter/material.dart';

class AvatarColor {
  final Color bg;
  final Color fg;
  const AvatarColor({required this.bg, required this.fg});
}

abstract final class AppColors {
  static const background = Color(0xFFF5F4F0);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE8E6E0);
  static const border2 = Color(0xFFD8D5CC);
  static const accent = Color(0xFF1A1A1A);
  static const accentGreen = Color(0xFF00C896);
  static const accentGreenBg = Color(0xFFE6FAF5);
  static const accentOrange = Color(0xFFFF6B35);
  static const text = Color(0xFF1A1A1A);
  static const text2 = Color(0xFF6B6860);
  static const text3 = Color(0xFFA8A49C);
  static const white = Color(0xFFFFFFFF);

  static const avatarPalette = [
    AvatarColor(bg: Color(0xFFFFF0AA), fg: Color(0xFFB8860B)),
    AvatarColor(bg: Color(0xFFD4EDDA), fg: Color(0xFF1A6B35)),
    AvatarColor(bg: Color(0xFFD6EAF8), fg: Color(0xFF1A5276)),
    AvatarColor(bg: Color(0xFFFDE8F0), fg: Color(0xFF8E1A4A)),
    AvatarColor(bg: Color(0xFFE8DAFF), fg: Color(0xFF4A1A8E)),
    AvatarColor(bg: Color(0xFFFFE5D4), fg: Color(0xFF8E3A1A)),
  ];
}
