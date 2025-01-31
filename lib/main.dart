import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/onboarding.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/data/prefrences.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Phoenix(child: lang()),
  );
}

class lang extends StatefulWidget {
  @override
  _langState createState() => _langState();
}

class _langState extends State<lang> {
  Future chooseLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("lang") == null) {
      prefs.setString("lang", "ar");
      return Locale(prefs.getString("lang"), '');
    } else {
      return Locale(prefs.getString("lang"), '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chooseLang(),
        builder: (context, snapshot) {
          return MyApp(snapshot.data);
        });
  }
}

class MyApp extends StatefulWidget {
  final Locale locale;

  MyApp(this.locale);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Matagger',
        theme: ThemeData(
          primaryColor: CustomColors.primary,
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: CustomColors.whiteBG),

          ),

        ),
        localizationsDelegates: [
          AppLocale.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        locale: widget.locale,
        localeResolutionCallback: (currentLocale, supportedLocales) {
          if (currentLocale != null) {
            print(currentLocale.countryCode);
            for (Locale locale in supportedLocales) {
              if (currentLocale.languageCode == locale.languageCode) {
                return currentLocale;
              }
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
            future: Preference.getAddress(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("address is  ${snapshot.data}");
                return HomeScreen();
              }
              return OnBoardingScreen();
            }));
  }

  Future<String> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("address");
    return datId;
  }
}
