import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get light {
    final theme = ThemeData.light();
    return theme.copyWith(
        backgroundColor: Color(0xfff1f1f1),
        scaffoldBackgroundColor: Color(0xfff0f0f0),
        tabBarTheme: TabBarTheme(
            unselectedLabelColor: Colors.grey, labelColor: theme.primaryColor),
        colorScheme: ColorScheme.light().copyWith(background: Colors.black12));
  }
}
