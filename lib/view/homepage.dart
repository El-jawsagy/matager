import 'dart:async';

import 'package:flutter/material.dart';
import 'package:matager/controller/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/market.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomePageApi homePage;

  @override
  void initState() {
    homePage = HomePageApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
      drawer: NavDrawer(),
      body: ListView(
        children: <Widget>[
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                child: Text(
                  AppLocale.of(context).getTranslated("app_name"),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          FutureBuilder(
              future: homePage.getAllCategory(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                print(snapshot.data);
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
              builder: (context) => CheckLocation(
                map["id"],
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? map["name"]
                    : map["name_en"],
              ),
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
                      Container(
                        width: 75,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7)),
                        child: Center(
                          child: Icon(Icons.arrow_forward_ios),
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
