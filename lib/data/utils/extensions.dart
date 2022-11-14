import 'package:flutter/material.dart';
import 'package:yarn_social_app/data/data.dart';
import 'package:yarn_social_app/styles/styles.dart';

extension AppThemeModeExtension on AppThemeMode {
  dynamic toTheme() {
    switch (this) {
      case AppThemeMode.light:
        return AppThemes.lightTheme();

      case AppThemeMode.dark:
        return AppThemes.darkTheme();

      case AppThemeMode.amoled:
        return AppThemes.amoledTheme();

      case AppThemeMode.system:
        return AppThemes.darkTheme();
    }
  }

  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;

      case AppThemeMode.light:
        return ThemeMode.light;

      case AppThemeMode.dark:
        return ThemeMode.dark;

      case AppThemeMode.amoled:
        return ThemeMode.dark;
    }
  }
}
