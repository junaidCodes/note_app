
import 'dart:ui';

import 'package:flutter/material.dart';
import 'controller/language_provider.dart';
import 'db_helper.dart';
import 'add_note.dart';
import 'home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child:   MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    localInitialization();
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = window.locale;
    // PlatformDispatcher.instance.onLocaleChanged = rebuildOnLocaleChange();

    return Consumer<LanguageProvider>(builder: (context, provider, child){
      return MaterialApp(
        locale: provider.langLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add this line
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('ur'),
        ],

        theme: ThemeData(fontFamily: myLocale.languageCode == 'ur' ? "jm" : "jm" ),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode,
        home: HomeScreen(toggleTheme: toggleTheme),
      );
    });
    

  }
   void localInitialization(){

   // localization.init(map)
   }
}
