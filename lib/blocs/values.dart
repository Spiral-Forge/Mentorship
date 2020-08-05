import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  // primarySwatch: Colors.red,
  // primaryColor: Colors.yellow,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  textSelectionColor: Colors.white,
  //accentIconTheme: IconThemeData(color: Colors.pink),
  dividerColor: Colors.black,
);

final lightTheme = ThemeData(
  // primarySwatch: Colors.grey,
  // primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  //accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
);