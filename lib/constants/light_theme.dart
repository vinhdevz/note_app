import 'package:flutter/material.dart';
import 'color.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: 'Lato',

  colorScheme: ColorScheme.light(
    primary: tdPurple,
    onPrimary: tdText,
    secondary: tdDarkPurple,
    
    onSecondary: tdWhite,
    surface: Colors.grey.shade200,
    tertiary: Color(0xFFE2E1FF),
    onSurface: tdBlack,
    error: tdRed,
    onError: tdWhite,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: tdBlack,
    elevation: 0,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: tdBlack),
    bodyMedium: TextStyle(color: tdGrey),
  ),
  iconTheme: IconThemeData(color: tdBlack),
  useMaterial3: true,
);
