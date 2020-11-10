import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/Favorite/favorite_items_and_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/prefrences.dart';
import 'package:matager/view/utilities/theme.dart';

import '../../homepage.dart';

class FavoriteOnLineScreen extends StatefulWidget {
  double latitude, longitude;

  FavoriteOnLineScreen(this.latitude, this.longitude);

  @override
  _FavoriteOnLineScreenState createState() => _FavoriteOnLineScreenState();
}

class _FavoriteOnLineScreenState extends State<FavoriteOnLineScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List allItems = [];
  FavoriteMethodAPI favoriteMethodAPI;

  @override
  void initState() {
    favoriteMethodAPI = FavoriteMethodAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocale.of(context).getTranslated("drawer_fav"),
            style: TextStyle(
              color: CustomColors.whiteBG,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        drawer: NavDrawer(widget.latitude, widget.longitude),
        body: FutureBuilder(
          future: Preference.getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: favoriteMethodAPI.getFavoriteItems(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                          child: Text(
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? "لم تختار أي عنصر حتى الآن"
                            : "You haven't taken any item yet",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ));
                      break;
                    case ConnectionState.waiting:
                      print("i'm here waiting");
                      return loading(context, 1);

                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      print("i'm here done");

                      if (snapshot.hasData) {
                        print(snapshot.data);
                        allItems = snapshot.data;

                        return snapshot.data.length > 0
                            ? Stack(
                                children: [
                                  ListView.builder(
                                    itemBuilder: (context, index) {
                                      return _drawCardOfStore(
                                          snapshot.data[index]);
                                    },
                                    itemCount: snapshot.data.length,
                                  ),
                                ],
                              )
                            : Column(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocale.of(context)
                                            .getTranslated("lang") ==
                                        'English'
                                    ? "لم تختار أي عنصر حتى الآن"
                                    : "You haven't taken any item yet",
                                    style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                    ),
                                  )
                                ],
                              );
                      }
                      return Center(
                          child: Text(
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? "لم تختار أي عنصر حتى الآن"
                            : "You haven't taken any item yet",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ));
                      break;
                  }
                  return Center(
                      child: Text(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? "لم تختار أي عنصر حتى الآن"
                        : "You haven't taken any item yet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ));
                },
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      AppLocale.of(context).getTranslated("apology"),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                          widget.latitude, widget.longitude)));
                            },
                            child: Text(
                              AppLocale.of(context).getTranslated("log"),
                              style: TextStyle(
                                color: CustomColors.whiteBG,
                              ),
                            ),
                            color: CustomColors.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _drawCardOfStore(
    map,
  ) {
    Map data = map["product"];
    double quan = map['quantity'];

    ValueNotifier<double> posOfProducts = ValueNotifier(quan);
    TextEditingController counterController = TextEditingController();
    counterController.text = posOfProducts.value.toString();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      height: MediaQuery.of(context).size.height * 0.15,
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    child: (data["image"] == null)
                        ? Image.asset(
                            "assets/images/boxImage.png",
                          )
                        : Image(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .2,
                            loadingBuilder: (context, image,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) {
                                return image;
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            image: NetworkImage(data["image"], scale: 1.0),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocale.of(context).getTranslated("lang") == 'English'
                          ? data["name_ar"]
                          : data["name_en"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ValueListenableBuilder(
                        valueListenable: posOfProducts,
                        builder:
                            (BuildContext context, double value, Widget child) {
                          return Center(
                            child: Text.rich(
                              data['offer']
                                  ? TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.red,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " ",
                                          style: TextStyle(
                                            color: CustomColors.red,
                                          ),
                                        ),
                                        new TextSpan(
                                          text:
                                              " ${(data["offer_price"]).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.primary,
                                          ),
                                        ),
                                      ],
                                    )
                                  : TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                _drawRemoveButton(
                  map,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawRemoveButton(Map data) {
    return InkWell(
      onTap: () async {
        favoriteMethodAPI.removeFavorite(data["id"]).then((value) {
          setState(() {});
          final snackBar = SnackBar(
            content: Text('Product removed from your favorites list'),
            duration: Duration(seconds: 3),
          );
          _scaffoldkey.currentState.showSnackBar(snackBar);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .09,
          height: MediaQuery.of(context).size.height * .04,
          decoration: BoxDecoration(
            color: CustomColors.gray,
            boxShadow: [
              BoxShadow(
                color: CustomColors.whiteBG,
                blurRadius: .75,
                spreadRadius: .75,
                offset: Offset(0.0, 0.0),
              )
            ],
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.trash,
                  color: CustomColors.whiteBG,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
