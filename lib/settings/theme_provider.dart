import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier { 
  bool _isDarkTheme = false; 
  bool get isDarkTheme => _isDarkTheme; 

  void toggleTheme() { 
    _isDarkTheme = !_isDarkTheme; 
    notifyListeners(); 
  }

  ThemeData get themeData { 
    return _isDarkTheme ? ThemeData.dark() : ThemeData.light(); 
  }
}
