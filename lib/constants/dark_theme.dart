import 'package:flutter/material.dart';
import 'color.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: tdBgColor,
  fontFamily: 'Lato',
  colorScheme: ColorScheme.dark(
    primary: tdPurple,
    onPrimary: tdGrey,
    secondary:  tdPurple,
    onSecondary: tdWhite,
   
    surface: tdGrey,
    tertiary:tdGrey,
    onSurface: tdWhite,
    error: tdRed,
    onError: tdWhite,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: tdBgColor,
    foregroundColor: tdWhite,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: tdWhite),
    bodyMedium: TextStyle(color: tdGrey2),
  ),
  iconTheme: IconThemeData(color: tdWhite),
  useMaterial3: true,
);
