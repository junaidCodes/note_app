import 'package:flutter/cupertino.dart';


class LanguageProvider extends ChangeNotifier {
  Locale? langLocale;

  void changeLang(Locale locale)  {

    langLocale = locale ;

    notifyListeners();
  }
}
