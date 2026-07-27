import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/core/theme/app_text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      brightness: Brightness.light,
      textTheme: AppTextTheme.textTheme,
    );
  }
}
