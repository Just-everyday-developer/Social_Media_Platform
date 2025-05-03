import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/settings/theme_provider.dart';
import 'package:social_media_platform/settings/font_slider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(
            'Settings',
            style: GoogleFonts.acme(fontSize: Provider.of<FontSlider>(context).sliderFontValue),
          )
        ),
        body: Column(
          children: [
                SwitchListTile( // кнопка с переключением плюс текст
                  title: Text(
                    "Dark Theme",
                    style: GoogleFonts.openSans(fontSize: Provider.of<FontSlider>(context).sliderFontValue),
                  ),
                  value: Provider.of<ThemeProvider>(context).isDarkTheme, // true - включено, false - нет
                  // Provider.of<T>(context) - позволяет дочерним классам использовать параметры и методы созданного экземпляра
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); // listen: true вызывает ошибку
                  }
                ),
                Column (
                  children: [
                    Text("The font size", style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
                    Slider(
                        label: Provider.of<FontSlider>(context).sliderFontValue.toInt().toString(),
                        min: 10,
                        max: 30,
                        divisions: 6,
                        value: Provider.of<FontSlider>(context).sliderFontValue,
                        onChanged: (value) {
                          Provider.of<FontSlider>(context, listen: false).setSliderValue(value);
                        }
                    )
                  ],
                )
                
          ]
      )
    );
  }
}