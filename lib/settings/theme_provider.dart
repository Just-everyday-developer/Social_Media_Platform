import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier { // with используется для связки класса с mixin
  bool _isDarkTheme = false; // устанавливаем переменную (инкапсуляция) с false
  bool get isDarkTheme => _isDarkTheme; // пишем геттер который вернет состояние isDarkTheme в виде свойства

  void toggleTheme() { // функция переключения
    _isDarkTheme = !_isDarkTheme; // меняем значение: светлый = темный и наоборот
    notifyListeners(); // говорим виджетам которые следят с помощью Provider/Consumer что значение поменялось
  }

  ThemeData get themeData { // это геттер которое возвращает значение под именем themeData
    return _isDarkTheme ? ThemeData.dark() : ThemeData.light(); // если стоит true то будет темно и наоборот
  }
}
