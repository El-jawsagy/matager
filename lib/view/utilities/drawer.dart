import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/Authentication_api.dart';
import 'package:matager/controller/store/home_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/user/cart/cart_offline.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/user/updata_profile.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/data/prefrences.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/view/user/address/address.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/view/user/favorite/favorite.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/view/user/orders/order.dart';

import '../about_us.dart';
import '../contact_us.dart';
import '../homepage.dart';
import '../terms_of_use.dart';
import 'multi_screen.dart';

class NavDrawer extends StatefulWidget {
  double lat, lng;

  NavDrawer(this.lat, this.lng);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  var token, name, email, photo, address;

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    name = prefs.getString("name");
    email = prefs.getString("email");
    photo = prefs.getString("photo");
    address = prefs.getString("address");
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    DrawerPageSize drawerPageSize = DrawerPageSize(detectedScreen);
    print("the token is :$token");
    return Drawer(
      child: FutureBuilder(
          future: Preference.getToken(),
          builder: (context, snapshot) {
            return ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: Stack(
                            children: [
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
                              (snapshot.hasData)
                                  ? Container(
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width:
                                                  drawerPageSize.imageWidthSize,
                                              height: drawerPageSize
                                                  .imageHeightSize,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(width: 1),
                                                  color: Colors.transparent),
                                              child: ClipOval(
                                                child: (photo == null ||
                                                        photo == '')
                                                    ? Image.asset(
                                                        'assets/images/image_2.jpg',
                                                      )
                                                    : Image(
                                                        loadingBuilder: (context,
                                                            image,
                                                            ImageChunkEvent
                                                                loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return image;
                                                          }
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        },
                                                        image: NetworkImage(
                                                            photo,
                                                            scale: 1.0),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(
                                                    name == null ? "" : name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: drawerPageSize
                                                            .userNameSize,
                                                        color: Colors.white),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: Text(
                                                    email == null ? "" : email,
                                                    style: TextStyle(
                                                        fontSize: drawerPageSize
                                                            .emailSize,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.22,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen(
                                                                widget.lat,
                                                                widget.lng)));
                                              },
                                              child: Text(
                                                AppLocale.of(context)
                                                    .getTranslated("log"),
                                              ),
                                              color: CustomColors.whiteBG,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        Column(
                          children: [
                            menuDrawer(
                              Icons.home,
                              AppLocale.of(context)
                                  .getTranslated('drawer_home'),
                              Icons.arrow_forward_ios,
                              () {
                                Navigator.pop(context);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                              drawerPageSize.iconSize,
                              drawerPageSize.titleSize,
                            ),
                            menuDrawer(
                              Icons.favorite,
                              AppLocale.of(context).getTranslated('drawer_fav'),
                              Icons.arrow_forward_ios,
                              () {
                                Navigator.pop(context);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FavoriteOnLineScreen(
                                                widget.lat, widget.lng)));
                              },
                              drawerPageSize.iconSize,
                              drawerPageSize.titleSize,
                            ),
                            menuDrawer(
                              Icons.shopping_cart,
                              AppLocale.of(context)
                                  .getTranslated('drawer_cart'),
                              Icons.arrow_forward_ios,
                              () {
                                if (token == null) {
                                  Navigator.pop(context);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CartOffLineScreen(
                                                  widget.lat, widget.lng)));
                                } else {
                                  Navigator.pop(context);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CartOnLineScreen(
                                                  widget.lat, widget.lng)));
                                }
                              },
                              drawerPageSize.iconSize,
                              drawerPageSize.titleSize,
                            ),
                            menuDrawer(
                              Icons.shopping_bag,
                              AppLocale.of(context)
                                  .getTranslated('drawer_order'),
                              Icons.arrow_forward_ios,
                              () {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderScreen(
                                            widget.lat, widget.lng)));
                              },
                              drawerPageSize.iconSize,
                              drawerPageSize.titleSize,
                            ),
                            menuDrawer(
                              Icons.location_on,
                              AppLocale.of(context)
                                  .getTranslated('drawer_address'),
                              Icons.arrow_forward_ios,
                              () {
                                Navigator.pop(context);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddressScreen(
                                            widget.lat, widget.lng)));
                              },
                              drawerPageSize.iconSize,
                              drawerPageSize.titleSize,
                            ),
                            menuDrawer(
                              Icons.error_outline,
                              AppLocale.of(context)
                                  .getTranslated('drawer_about'),
                              Icons.arrow_forward_ios,
                              () {
                                Navigator.pop(context);

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AboutUsScreen()));
                              },
                              drawerPageSize.iconSize,
                              drawerPageSize.titleSize,
                            ),
                            (!snapshot.hasData)
                                ? Container()
                                : menuDrawer(
                                    Icons.settings,
                                    AppLocale.of(context)
                                        .getTranslated('drawer_update'),
                                    Icons.arrow_forward_ios,
                                    () async {
                                      Authentication auth = Authentication();
                                      await auth
                                          .getUser(snapshot.data)
                                          .then((value) {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateProfileScreen(
                                                        value, snapshot.data)));
                                      });
                                    },
                                    drawerPageSize.iconSize,
                                    drawerPageSize.titleSize,
                                  ),
                            menuDrawer(
                              FontAwesomeIcons.fileAlt,
                              AppLocale.of(context)
                                  .getTranslated('drawer_terms'),
                              Icons.arrow_forward_ios,
                              () {
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TermsOfUseScreen()));
                              },
                              drawerPageSize.iconSize,
                              drawerPageSize.titleSize,
                            ),
                            (!snapshot.hasData)
                                ? Container()
                                : menuDrawer(
                                    Icons.exit_to_app,
                                    AppLocale.of(context)
                                        .getTranslated('drawer_sign_out'),
                                    Icons.arrow_forward_ios,
                                    () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setString("token", null);
                                      prefs.setString("cart", null);
                                      prefs.setString("favorite", null);
                                      prefs.setString("UserId", null);

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    },
                                    drawerPageSize.iconSize,
                                    drawerPageSize.titleSize,
                                  ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8.0, right: 8.0),
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.only(right: 10, left: 10),
                                dense: true,
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
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Icon(
                                    Icons.language,
                                    color: CustomColors.primary,
                                    size: 22,
                                  ),
                                ),
                                title: Text(
                                  AppLocale.of(context)
                                      .getTranslated('lang_display'),
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Text(
                                  AppLocale.of(context).getTranslated('lang'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 14, left: 14),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            menuDrawerBottom(
                                Icons.feedback,
                                AppLocale.of(context)
                                    .getTranslated("drawer_feed"), () async {
                              if (snapshot.hasData) {
                                MarketAndCategoryApi homePage =
                                    MarketAndCategoryApi();
                                await homePage.getAllCategory().then((value) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ContactUsScreen(
                                                value,
                                                AppLocale.of(context)
                                                    .getTranslated("lang"),
                                              )));
                                });
                              } else {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen(
                                            widget.lat, widget.lng)));
                              }
                            }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  Widget menuDrawer(leading, title, trailing, function, iconSize, titleSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.only(right: 10),
        dense: true,
        onTap: function,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Icon(
            leading,
            color: CustomColors.primary,
            size: iconSize,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: titleSize),
        ),
        trailing: Icon(
          trailing,
          size: iconSize,
          color: CustomColors.primary,
        ),
      ),
    );
  }

  Widget menuDrawerBottom(leading, title, function) {
    return Container(
      width: 145,
      child: ListTile(
        onTap: function,
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
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.8, size.width, size.height * 0.1);
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
    path.lineTo(0, size.height * 0.9);
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.9, size.width, size.height * 0.15);
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
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width * 0.8, size.height, size.width, size.height * 0.19);
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
