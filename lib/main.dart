import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:social_media_platform/router.dart";
import "package:social_media_platform/settings/font_slider.dart";
import "settings/theme_provider.dart";

void main() {
  runApp(
    MultiProvider( // для управления темой, цветом, шрифом одновременно
      /* ChangeNotifierProvider данный виджет из пакета provider.
      Управляет состоянием и говорит всем на него подписанным виджетам об изменении.
      В коде он следит за ThemeProvider используя context чтобы понять местоположение (источник)
      */
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(), // создаем наблюдение за нашим классом который связан с ChangeNotifier
        ),
        ChangeNotifierProvider(
          create: (context) => FontSlider(), // делаем наблюдение за слайдером для шрифта
        ),
      ],

      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "The flutter app",
      theme: Provider.of<ThemeProvider>(context).themeData,
      routerConfig: router,
    );
  }
}

