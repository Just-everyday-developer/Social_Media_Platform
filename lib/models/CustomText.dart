import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/settings/font_slider.dart';

class CustomText extends StatelessWidget {
  final String message;
  final TextStyle? style;
  const CustomText({super.key, required this.message, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(message, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue));
  }
}