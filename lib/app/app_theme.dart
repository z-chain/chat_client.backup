import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get light => ThemeData.light().copyWith(
      backgroundColor: Color(0xfff1f1f1),
      scaffoldBackgroundColor: Color(0xfff0f0f0),
      colorScheme: ColorScheme.light().copyWith(background: Colors.black12));
}
