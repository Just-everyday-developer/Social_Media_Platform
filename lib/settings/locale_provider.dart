import 'package:flutter/widgets.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}

class L10n {
  static const supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('kk'),
  ];
}
