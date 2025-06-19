import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:social_media_platform/settings/theme_provider.dart';
import 'package:social_media_platform/settings/font_slider.dart';
import '../generated/l10n.dart';        

import '../settings/locale_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();
    return Scaffold(
        body: Column(
          children: [
                SwitchListTile( 
                  title: Text(
                    S.of(context).dark_theme,
                    style: GoogleFonts.openSans(fontSize: Provider.of<FontSlider>(context).sliderFontValue),
                  ),
                  value: Provider.of<ThemeProvider>(context).isDarkTheme, 
                  
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(); 
                  }
                ),
                Column (
                  children: [
                    Text(S.of(context).font_size, style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue)),
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
                ),
            const Divider(),
            ListTile(
              title: Text(S.of(context).language),
              trailing: DropdownButton<Locale>(
                value: provider.locale,
                items: L10n.supportedLocales.map((locale) {
                  final flag = {
                    'en': '🇬🇧',
                    'ru': '🇷🇺',
                    'kk': '🇰🇿',
                  }[locale.languageCode];
                  final name = {
                    'en': 'English',
                    'ru': 'Русский',
                    'kk': 'Қазақша',
                  }[locale.languageCode];
                  return DropdownMenuItem(
                    value: locale,
                    child: Text('$flag  $name'),
                  );
                }).toList(),
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    provider.setLocale(newLocale);
                  }
                }),
            ),
          ]
      )
    );
  }
}