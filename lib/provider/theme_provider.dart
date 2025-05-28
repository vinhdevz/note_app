import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/dark_theme.dart';
import 'package:flutter_todo_app/constants/light_theme.dart';


class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeNotifier(this._themeData, this._isDarkMode);

  ThemeData getTheme() => _themeData;
  bool isDarkMode() => _isDarkMode;

  void toggleTheme(bool isDark) {
    _themeData = isDark ? darkTheme : lightTheme;
    _isDarkMode = isDark;
    notifyListeners();
  }
}
