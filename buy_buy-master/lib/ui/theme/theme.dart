import 'package:flutter/material.dart';

final _primaryColor = Color(0xff001a6e);
var _textTheme = TextTheme(
  displayLarge: TextStyle(color: _primaryColor),
  displayMedium: TextStyle(color: _primaryColor),
  displaySmall: TextStyle(color: _primaryColor),
  headlineLarge: TextStyle(color: _primaryColor),
  headlineMedium: TextStyle(color: _primaryColor),
  titleLarge: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
  titleMedium: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
  titleSmall: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
  labelLarge: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
  labelMedium: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
  labelSmall: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
  bodyLarge: TextStyle(color: _primaryColor),
  bodyMedium: TextStyle(color: _primaryColor),
  bodySmall: TextStyle(color: _primaryColor),
);

final _listTileTheme = ListTileThemeData(
  textColor: _primaryColor,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

final _appBarTheme = AppBarTheme(
  titleTextStyle: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600, fontSize: 24, fontFamily: 'MarkPro'),
);

final themeData = ThemeData(
  useMaterial3: true,
  primaryColor: _primaryColor,
  colorScheme: ColorScheme.fromSeed(seedColor: _primaryColor),
  highlightColor: Color(0xffe1ffbb),
  hintColor: Color(0xff009990),
  disabledColor: Color(0xff2e57de),
  fontFamily: 'MarkPro',
  textTheme: _textTheme,
  appBarTheme: _appBarTheme,
  listTileTheme: _listTileTheme,
);
