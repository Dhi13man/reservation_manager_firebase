import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:provider/provider.dart';

class AppConstants extends ChangeNotifier {
  bool _isThemeLight = true;

  AppConstants() {
    findTheme();
  }

  /// Getters
  MaterialColor get getForeGroundColor =>
      (_isThemeLight) ? Colors.indigo : Colors.amber;

  MaterialColor get getLighterForeGroundColor =>
      (_isThemeLight) ? Colors.blue : Colors.yellow;

  Color get getBackGroundColor => (_isThemeLight) ? Colors.white : Colors.black;

  /// Other Functions
  void findTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isThemeLight = prefs.getBool('isThemeLight') ?? true;

    await prefs.setBool('isThemeLight', _isThemeLight);
    notifyListeners();
  }

  void toggleTheme() async {
    _isThemeLight = !_isThemeLight;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isThemeLight', _isThemeLight);
  }
}
