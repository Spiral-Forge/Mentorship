import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dbapp/services/storage.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  dividerColor: Colors.black,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  dividerColor: Colors.white54,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  bool _darktheme;
  SharedPreferences prefs;
  bool get darkTheme => _darktheme;

  ThemeNotifier() {
    _darktheme = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darktheme = !_darktheme;
    _saveToPrefs();
    notifyListeners();
  }

  _loadFromPrefs() async {
    var val = await StorageServices.getDarkMode();
    _darktheme = val != null ? val : false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await StorageServices.saveDarkMode(_darktheme);
  }
}
