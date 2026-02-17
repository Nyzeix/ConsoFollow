import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  final SharedPreferences _preferences; 
  bool isDarkMode;

  ThemeController(this._preferences) 
      : isDarkMode = _preferences.getBool('isDarkMode') ?? false; 

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
    _preferences.setBool('isDarkMode', isDarkMode);
  }
}