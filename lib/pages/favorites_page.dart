import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_platform/pages/settings_page.dart';
import 'package:social_media_platform/settings/font_slider.dart';
import 'package:provider/provider.dart';

import '../models/Post.dart';
import '../models/PostSearchDelegate.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 200),
        Text("Not Favorites",
        style: TextStyle(fontSize: Provider.of<FontSlider>(context).sliderFontValue * 1.5))
      ],
    );
  }
}