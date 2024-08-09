

import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/newScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/language_provider.dart';
import 'db_helper.dart';
import 'add_note.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  SharedPreferences sp = await SharedPreferences.getInstance();
  String? langCode = sp.getString('langCode') ?? 'en'; // Default to English
  OneSignal.initialize('7ba16e95-9f98-46df-8f21-33da1d508e6d');
  OneSignal.Notifications.requestPermission(true);
  // OneSignal.Notifications.displayNotification(notificationId)


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(initialLocale:
            Locale(langCode),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
final key = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool isOn = false;


  void toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  void initState() {
    super.initState();
    localInitialization();
    getData();

  }
  void dispose(){
    getData();
    super.dispose();
  }

  void getData() {

    OneSignal.Notifications.addClickListener((event) {

      log((event.notification.jsonRepresentation()));

      if (isOn) return;

      final data = event.notification.additionalData;
      final navigateToScreen = data?['navigate'];
      if (navigateToScreen != null) {
        if (navigateToScreen == 'true') {
          key.currentState?.pushNamed('note');
        } else if (navigateToScreen == 'false') {
          key.currentState?.pushNamed('home');
        } else {
          key.currentState?.pushNamed('home');

        }


        isOn = true;

        Future.delayed(const Duration(seconds: 2), () {
          isOn = false;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    return Consumer<LanguageProvider>(builder: (context, provider, child) {
      final textTheme = ThemeData.light().textTheme.apply(
        fontFamily: provider.langLocale == const Locale('ur') ? 'jm' : 'jm',
      );
      final darkTextTheme = ThemeData.dark().textTheme.apply(
        fontFamily: provider.langLocale == const Locale('ur') ? 'jm' : 'jm',
      );

      return MaterialApp(
        initialRoute: 'home',
        routes: {


          'home': (context) => HomeScreen(  toggleTheme: toggleTheme,),
          'note': (context) => NoteScreen( toggleTheme: toggleTheme),
        },
        navigatorKey: key,
        debugShowCheckedModeBanner: false,
        locale: provider.langLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ur'),
        ],
        theme: ThemeData(
          textTheme: textTheme,
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: darkTextTheme,
        ),
        themeMode: _themeMode,
        // home: HomeScreen(toggleTheme: toggleTheme),
      );
    });
  }

  void localInitialization() {
    // localization.init(map)
  }
}
