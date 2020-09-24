import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/prefrences.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  var token, name, email;

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    name = prefs.getString("name");
    email = prefs.getString("email");
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.3,
            child: CustomPaint(
              painter: TopBackground3(),
              child: Container(),
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: CustomPaint(
              painter: TopBackground2(),
              child: Container(),
            ),
          ),
          CustomPaint(
            painter: TopBackground1(),
            child: Container(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  token == null
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {},
                                  child: Text(
                                    AppLocale.of(context).getTranslated("log"),
                                  ),
                                  color: CustomColors.whiteBG,
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 58, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: ExactAssetImage(
                                              'assets/images/image_2.jpg'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 0.4)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        email,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 20),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  menuDrawer(
                      Icons.home,
                      AppLocale.of(context).getTranslated('drawer_home'),
                      Icons.arrow_forward_ios),
                  menuDrawer(
                      Icons.favorite,
                      AppLocale.of(context).getTranslated('drawer_fav'),
                      Icons.arrow_forward_ios),
                  menuDrawer(
                      Icons.shopping_cart,
                      AppLocale.of(context).getTranslated('drawer_cart'),
                      Icons.arrow_forward_ios),
                  menuDrawer(
                      Icons.shopping_bag,
                      AppLocale.of(context).getTranslated('drawer_order'),
                      Icons.arrow_forward_ios),
                  menuDrawer(
                      Icons.location_on,
                      AppLocale.of(context).getTranslated('drawer_address'),
                      Icons.arrow_forward_ios),
                  menuDrawer(
                      Icons.share,
                      AppLocale.of(context).getTranslated('drawer_share'),
                      Icons.arrow_forward_ios),
                  menuDrawer(
                      Icons.error_outline,
                      AppLocale.of(context).getTranslated('drawer_about'),
                      Icons.arrow_forward_ios),
                  token == null
                      ? Container()
                      : menuDrawer(
                          Icons.exit_to_app,
                          AppLocale.of(context)
                              .getTranslated('drawer_sign_out'),
                          Icons.arrow_forward_ios),
                  ListTile(
                    contentPadding: EdgeInsets.only(right: 10),
                    dense: true,
                    onTap: () {},
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Icon(
                        Icons.language,
                        color: CustomColors.primary,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      AppLocale.of(context).getTranslated('lang_display'),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                        onTap: () async {
                          String lang = await Preference.getLanguage();
                          if (lang == 'ar') {
                            setState(() {
                              setLang('en');
                              Phoenix.rebirth(context);
                            });
                          } else {
                            setState(() {
                              setLang('ar');
                              Phoenix.rebirth(context);
                            });
                          }
                        },
                        child: Center(
                          child: Text(
                            AppLocale.of(context).getTranslated('lang'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      menuDrawerBottom(
                        Icons.feedback,
                        AppLocale.of(context).getTranslated("drawer_feed"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey[300],
                      ),
                      menuDrawerBottom(
                        Icons.help,
                        AppLocale.of(context).getTranslated("drawer_help"),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget menuDrawer(leading, title, trailing) {
    return ListTile(
      contentPadding: EdgeInsets.only(right: 10),
      dense: true,
      onTap: () {},
      leading: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Icon(
          leading,
          color: CustomColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(
        trailing,
        size: 18,
        color: CustomColors.primary,
      ),
    );
  }

  Widget menuDrawerBottom(leading, title) {
    return Container(
      width: 145,
      child: ListTile(
        onTap: () {},
        dense: true,
        leading: Icon(
          leading,
          color: CustomColors.primary,
          size: 16,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}

class TopBackground1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.24);
    Gradient gradient = LinearGradient(colors: [
      CustomColors.primary,
      CustomColors.primary,
    ], stops: [
      0.3,
      0.8
    ]);
    Paint paint = Paint();
    paint.shader = gradient.createShader(rect);
//    paint.color=Colors.blue[600];
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.20, size.width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TopBackground2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.24);
    Gradient gradient = LinearGradient(colors: [
      CustomColors.primary,
      CustomColors.primary,
    ], stops: [
      0.3,
      0.8
    ]);
    Paint paint = Paint();
    paint.shader = gradient.createShader(rect);
//    paint.color=Colors.blue[600];
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.215);
    path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.235, size.width, size.height * 0.09);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TopBackground3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.24);
    Gradient gradient = LinearGradient(colors: [
      CustomColors.primary,
      CustomColors.primary,
    ], stops: [
      0.3,
      0.8
    ]);
    Paint paint = Paint();
    paint.shader = gradient.createShader(rect);
//    paint.color=Colors.blue[600];
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.23);
    path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.27, size.width, size.height * 0.15);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Future setLang(String lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lang", lang);
}
