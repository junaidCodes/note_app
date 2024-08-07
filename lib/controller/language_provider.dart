
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale? langLocale;


  LanguageProvider({required Locale initialLocale}) {
    langLocale = initialLocale;
  }

  void changeLang(Locale locale) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    langLocale = locale;
    await sp.setString('langCode', locale.languageCode);
    notifyListeners();
  }
}
