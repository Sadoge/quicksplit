import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double card = 18.0;
  static const double inner = 12.0;
  static const double pill = 20.0;
  static const double avatar = 999.0;

  static final cardBorder = BorderRadius.circular(card);
  static final innerBorder = BorderRadius.circular(inner);
  static final pillBorder = BorderRadius.circular(pill);
  static final avatarBorder = BorderRadius.circular(avatar);
}
