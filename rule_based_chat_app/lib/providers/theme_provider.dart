import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode_is_dark';

  ThemeProvider._(this._themeMode);

  ThemeMode _themeMode;
  bool _isLoaded = false;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  bool get isLoaded => _isLoaded;

  static ThemeProvider create() {
    return ThemeProvider._(ThemeMode.light);
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeModeKey) ?? false;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _isLoaded = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, isDarkMode);

    notifyListeners();
  }
}
