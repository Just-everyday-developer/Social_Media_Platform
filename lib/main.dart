import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:provider/provider.dart";
import "package:social_media_platform/pages/MapPage.dart";
import "package:social_media_platform/router.dart";
import "package:social_media_platform/settings/font_slider.dart";
import "package:social_media_platform/settings/locale_provider.dart";
import "settings/theme_provider.dart";
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';           


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider( 
      /* ChangeNotifierProvider данный виджет из пакета provider.
      Управляет состоянием и говорит всем на него подписанным виджетам об изменении.
      В коде он следит за ThemeProvider используя context чтобы понять местоположение (источник)
      */
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
          child: const MyApp(),
        ),
        ChangeNotifierProvider(
            create: (context) => MapState()),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(), 
        ),
        ChangeNotifierProvider(
          create: (context) => FontSlider(), 
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
    final locale = context.watch<LocaleProvider>().locale;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "The flutter app",
      theme: Provider.of<ThemeProvider>(context).themeData,
      routerConfig: router,
      locale: locale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

