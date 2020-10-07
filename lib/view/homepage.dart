import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/get_location.dart';
import 'package:matager/view/supermarket/market.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  double latitude, longitude;

  String locationDetails;

  HomeScreen(this.latitude, this.longitude, this.locationDetails);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MarketAndCategoryApi homePage;

  @override
  void initState() {
    homePage = MarketAndCategoryApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        title: Text(
          AppLocale.of(context).getTranslated("app_name"),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textWidthBasis: TextWidthBasis.parent,
          textAlign: TextAlign.right,
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.05,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CheckLocation()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        widget.locationDetails,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: CustomColors.whiteBG,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: CustomColors.whiteBG,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: NavDrawer(widget.latitude, widget.longitude),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
              future: homePage.getAllCategory(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return emptyPage(context);
                    break;
                  case ConnectionState.waiting:

                  case ConnectionState.active:
                    return loading(context);
                    break;
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          itemBuilder: (context, pos) {
                            return _drawCardOfStore(
                              snapshot.data[pos],
                            );
                          },
                        ),
                      );
                    } else
                      return emptyPage(context);
                    break;
                }
                return emptyPage(context);
              }),
        ],
      ),
    );
  }

  Widget _drawCardOfStore(Map map) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Markets(
                  map["id"],
                  AppLocale.of(context).getTranslated("lang") == 'English'
                      ? map["name"]
                      : map["name_en"],
                  widget.latitude,
                  widget.longitude),
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: (map["image"] == null)
                    ? Image.asset(
                        "assets/images/boxImage.png",
                      )
                    : Image(
                        loadingBuilder:
                            (context, image, ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            return image;
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        image: NetworkImage(
                            AppLocale.of(context).getTranslated("lang") ==
                                    'English'
                                ? map["image"]
                                : map["image_en"],
                            scale: 1.0),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Opacity(
                        opacity: 0.8,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .15,
                          height: MediaQuery.of(context).size.height * .05,
                          decoration: BoxDecoration(
                              color: CustomColors.primary,
                              borderRadius: BorderRadius.circular(9)),
                          child: Center(
                            child: Icon(
                              Icons.shopping_cart,
                              color: CustomColors.whiteBG,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future setLang(String lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lang", lang);
}
