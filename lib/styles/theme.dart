import 'package:flutter/material.dart';

mixin AppThemes {
  static lightTheme() => ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      );
  static darkTheme() => ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      );

  static amoledTheme() => ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Colors.black),
        scaffoldBackgroundColor: Colors.black54,
      );
}

