import 'package:flutter/material.dart';
import 'package:noteapp/Themes/app_colors.dart';

class MyAppThemes {
  static final darkTheme = ThemeData(
primaryColor: MyAppColors.lightBlue,
    brightness: Brightness.light
  );

  static final lightTheme = ThemeData(primaryColor:
  MyAppColors.darkBlue,
    brightness: Brightness.dark
  );


}