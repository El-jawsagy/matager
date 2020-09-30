import 'package:flutter/material.dart';

class CustomColors {
  static String appName = "Hyperion ToDo App";

  static Color lightPrimary = Color(0xff7B68EE);
  static Color dark = Colors.black;
  static Color darkOne = Colors.black12;

  static Color blueOne = Colors.red.shade600;
  static Color blueThree = Colors.red[300];
  static Color darkBlue = Color(0xff17223b);
  static Color darkRed = Colors.red.shade700;
  static Color gray = Colors.grey;
  static Color grayOne = Colors.grey[200];
  static Color grayTow = Colors.grey[300];
  static Color primary = Color(0xff0101b2);

  static Color whiteBG = Colors.white;
  static Color ratingBG = Colors.yellow[600];
  static Color offWhite = Colors.white54;
  static Color red = Colors.red[600];

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
