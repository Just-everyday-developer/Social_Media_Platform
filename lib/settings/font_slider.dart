import 'package:flutter/material.dart';

class FontSlider with ChangeNotifier {
  double _defaultFontValue = 15;
  double get sliderFontValue => _defaultFontValue;

  void setSliderValue(double value) {
    _defaultFontValue = value;
    notifyListeners();
  }

}