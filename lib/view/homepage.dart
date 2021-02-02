import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/cart/cart_items_bloc_and_Api.dart';
import 'package:matager/controller/store/home_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/get_location.dart';
import 'package:matager/view/supermarket/market.dart';
import 'package:matager/view/user/cart/cart_offline.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

//todo: make cart choice between before login and after that
ValueNotifier<int> countOfProducts = ValueNotifier(0);

void getCounterProduct() {
  SharedPreferences.getInstance().then((SharedPreferences value) {
    SharedPreferences prefs = value;
    int count = 0;

    if (prefs.get("token") == null) {
      String data = prefs.getString("cart");
      if (data != null) {
        var cart = json.decode(prefs.getString("cart"));
        if (cart != null || cart != "null") {
          print(cart);
          count =
              cart['cart_items'].length == null ? 0 : cart['cart_items'].length;
          countOfProducts.value = count;
        } else {
          countOfProducts.value = count;
        }
      } else {
        countOfProducts.value = count;
      }
    } else {
      countOfProducts.value = count;
      getCount().then((value) {
        countOfProducts.value = value;
      });
    }
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final GlobalKey<ScaffoldState> homePageScaffoldKey =
    new GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen> {
  MarketAndCategoryApi homePage;

  double latitude, longitude;
  String locationDetails, token;
  ValueNotifier<double> posOfProducts;
  CarouselController _controller;

  @override
  void initState() {
    posOfProducts = ValueNotifier(0);
    _controller = CarouselController();
    homePage = MarketAndCategoryApi();
    SharedPreferences.getInstance().then((SharedPreferences value) {
      SharedPreferences prefs = value;

      latitude = prefs.getDouble("lat");
      longitude = prefs.getDouble("lng");
      print(latitude);
      print(longitude);
      token = prefs.getString("token");
      locationDetails = prefs.get("address");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getCounterProduct();
    DetectedScreen detectedScreen = DetectedScreen(context);
    HomePageSize homePageSize = HomePageSize(detectedScreen);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: homePageScaffoldKey,
        backgroundColor: CustomColors.whiteBG,
        appBar: AppBar(
          title: Image.asset(AppLocale.of(context).getTranslated("image")),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            ValueListenableBuilder(
              valueListenable: countOfProducts,
              builder: (BuildContext context, int value, Widget child) {
                return Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: CustomColors.red, shape: BoxShape.circle),
                          child: Text(countOfProducts.value.toString()),
                        ),
                      ],
                    ),
                    IconButton(
                      iconSize: homePageSize.iconHeaderSize,
                      onPressed: () {
                        print(token);
                        if (token == null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartOffLineScreen(latitude, longitude)));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CartOnLineScreen(latitude, longitude)));
                        }
                      },
                      icon: Icon(
                        Icons.shopping_cart,
                      ),
                    ),
                  ],
                );
              },
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckLocation(0)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Text(
                          locationDetails,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: homePageSize.nameSize,
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
                        size: homePageSize.iconSize,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        drawer: NavDrawer(latitude, longitude),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: FutureBuilder(
                    future: homePage.getSliderImages(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return emptyPage(context);
                          break;
                        case ConnectionState.waiting:

                        case ConnectionState.active:
                          return loading(context, 0.25);
                          break;
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            return _drawSlider(
                                snapshot.data, homePageSize.iconSize);
                          } else
                            return emptyPage(context);
                          break;
                      }
                      return emptyPage(context);
                    }),
              ),
              _drawTextMatagger(homePageSize.headerTextSize),
              Container(
                child: FutureBuilder(
                    future: homePage.getAllCategory(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return emptyPage(context);
                          break;
                        case ConnectionState.waiting:

                        case ConnectionState.active:
                          return loading(context, 0.75);
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
                                  return _drawCardOfStore(snapshot.data[pos],
                                      homePageSize.iconSize);
                                },
                              ),
                            );
                          } else
                            return emptyPage(context);
                          break;
                      }
                      return emptyPage(context);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

// draw slider image for offer and last images
  Widget _drawSlider(List images, fontSize) {
    return ValueListenableBuilder(
        valueListenable: posOfProducts,
        builder: (BuildContext context, double value, Widget child) {
          return Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .25,
                child: CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int index) {
                    String image =
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? images[index]["image"]
                            : images[index]["image_en"];
                    return Container(
                      child: (image == null)
                          ? Image.asset(
                              "assets/images/boxImage.png",
                            )
                          : Image(
                              loadingBuilder: (context, image,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) {
                                  return image;
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              image: NetworkImage(
                                image,
                              ),
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlayCurve: Curves.easeInOutSine,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 200),
                    viewportFraction: 1,
                    initialPage: 0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: InkWell(
                            onTap: () {
                              if (posOfProducts.value == images.length - 1) {
                                _controller.jumpToPage(0);
                                posOfProducts.value = 0;
                              } else {
                                _controller.jumpToPage(
                                    posOfProducts.value.floor() + 1);
                              }
                              print(posOfProducts);
                              print(images.length);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: MediaQuery.of(context).size.height * .06,
                              decoration: BoxDecoration(
                                color: CustomColors.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: CustomColors.whiteBG,
                                size: fontSize,
                              ),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: InkWell(
                            onTap: () {
                              if (posOfProducts.value <= 0) {
                                _controller.jumpToPage(images.length - 1);
                                posOfProducts.value =
                                    images.length.ceilToDouble() - 1;
                              } else {
                                _controller.jumpToPage(
                                    posOfProducts.value.floor() - 1);
                              }
                              print(posOfProducts);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.08,
                              height: MediaQuery.of(context).size.height * .06,
                              decoration: BoxDecoration(
                                color: CustomColors.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: CustomColors.whiteBG,
                                  size: fontSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Widget _drawTextMatagger(fontSize) {
    return Text(
      AppLocale.of(context).getTranslated("our_store"),
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: CustomColors.primary),
    );
  }

  // display category of all stores
  Widget _drawCardOfStore(Map map, iconSize) {
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
                  token,
                  latitude,
                  longitude),
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
                              size: iconSize,
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

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            actionsPadding: EdgeInsets.all(16),
            title: new Text(
                AppLocale.of(context).getTranslated("lang") == "English"
                    ? 'هل أنت متأكد؟'
                    : 'Are you sure?'),
            content: new Text(
                AppLocale.of(context).getTranslated("lang") == "English"
                    ? 'هل تريد الخروج من التطبيق؟'
                    : 'Do you want to exit the App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(
                    AppLocale.of(context).getTranslated("lang") == "English"
                        ? 'لا'
                        : "NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () async => await SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop'),
                child: Text(
                    AppLocale.of(context).getTranslated("lang") == "English"
                        ? 'نعم'
                        : "YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

Future setLang(String lang) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("lang", lang);
}
