import 'package:flutter/material.dart';

class CustomColors {
  static String appName = "Hyperion ToDo App";

  static Color lightPrimary = Color(0xff7B68EE);
  static Color dark = Colors.black;
  static Color darkOne = Colors.black12;

  static Color blueOne = Colors.red.shade600;
  static Color blueThree = Color(0xff060691);
  static Color darkBlue = Color(0xff17223b);
  static Color darkRed = Colors.red.shade700;
  static Color gray = Colors.grey;
  static Color grayOne = Color(0xffa5a5a5);
  static Color grayTow = Color(0xffe9eef2);
  static Color grayThree = Color(0xfff1f1f1);
  static Color grayText = Color(0xff495057);
  static Color grayBorder = Color(0xffcdc9c3);

  static Color primary = Color(0xff0101b2);

  static Color whiteBG = Colors.white;
  static Color ratingBG = Colors.yellow[600];
  static Color ratingLightBG = Color(0xfffff3cd);
  static Color ratingLightFont = Color(0xff906404);
  static Color greenBG = Colors.green[600];

  static Color greenLightBG = Color(0xffD4EDDA);
  static Color greenLightFont = Color(0xff008000);

  static Color offWhite = Colors.white54;
  static Color red = Colors.red[600];
  static Color redLightBG = Color(0xffff727e);
  static Color redLightFont = Color(0xffc82333);
  static ThemeData lightTheme = ThemeData(
    backgroundColor: darkRed,
    primaryColor: lightPrimary,
    accentColor: blueOne,
    cursorColor: darkBlue,
    scaffoldBackgroundColor: darkRed,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: whiteBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    canvasColor: CustomColors.darkRed,
    brightness: Brightness.dark,
    backgroundColor: whiteBG,
    primaryColor: dark,
    accentColor: darkBlue,
    scaffoldBackgroundColor: whiteBG,
    cursorColor: whiteBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        title: TextStyle(
          color: darkRed,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}
