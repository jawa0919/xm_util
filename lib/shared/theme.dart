import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const List<MaterialColor> eggshellColors = [
    Colors.blue,
    Colors.teal,
    Colors.yellow,
    Colors.green,
  ];

  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1), // 与网页主题一致的紫色
    primary: const Color(0xFF6366F1),
    secondary: const Color(0xFF4F46E5),
    tertiary: const Color(0xFFEC4899),
  );

  static final ThemeData _themeData = ThemeData(colorScheme: colorScheme);

  static get themeData => _themeData.copyWith(
    appBarTheme: _themeData.appBarTheme.copyWith(
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
