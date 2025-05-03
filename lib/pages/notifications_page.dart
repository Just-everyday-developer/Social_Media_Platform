import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:social_media_platform/settings/font_slider.dart";

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Text(
            "No notifications",
            style: TextStyle(
              fontSize: Provider.of<FontSlider>(context).sliderFontValue)
      ),
    );
  }
}