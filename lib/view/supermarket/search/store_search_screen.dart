import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/store/search_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';

import '../display_supermarket.dart';
import '../store_comments.dart';

class StoreSearchScreen extends SearchDelegate {
  int id;
  double lat, lng;
  String token;

  StoreSearchScreen(this.id, this.lat, this.lng, this.token);

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: CustomColors.primary,
      primaryIconTheme:
          theme.primaryIconTheme.copyWith(color: Colors.grey[200]),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: TextTheme(
        headline1: TextStyle(color: CustomColors.whiteBG),
        headline2: TextStyle(color: CustomColors.whiteBG),
      ),
    );
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Search for Stores';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    SearchProductsAndStoresApi searchProductsAndStoresApi =
        SearchProductsAndStoresApi();
    DetectedScreen detectedScreen = DetectedScreen(context);
    CategorySize categorySize = CategorySize(detectedScreen);
    return FutureBuilder(
        future: searchProductsAndStoresApi.getStores(
          query,
          this.id,
          this.lat,
          this.lng,
        ),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return emptyPage(context);
              break;
            case ConnectionState.waiting:
              return loading(context, 1);
              break;
            case ConnectionState.active:

            case ConnectionState.done:
              if (snapshot.hasData) {
                return snapshot.data.length >= 1
                    ? ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return _drawCardOfStore(
                              context,
                              snapshot.data[index],
                              categorySize.nameSize,
                              categorySize.iconSize,
                              categorySize.smallNameSize,
                              categorySize.smallIconSize);
                        },
                        itemCount: snapshot.data.length,
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Image.asset(
                                  "assets/images/box.jpg",
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        "English"
                                    ? " لا يوجد متجر بهذا الاسم ' ${this.query} '  في الوقت الحالي "
                                    : "There is no store with this name ' ${this.query} ' at this time  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: categorySize.headerTextSize),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ));
              } else
                return emptyPage(context);
              break;
          }
          return emptyPage(context);
        });
  }

  Widget _drawCardOfStore(BuildContext context, Map data, nameSize, iconSize,
      smallNameSize, smallIconSize) {
    ValueNotifier<bool> posOfProducts = ValueNotifier(false);

    return ValueListenableBuilder(
      valueListenable: posOfProducts,
      builder: (BuildContext context, bool value, Widget child) {
        return AnimatedContainer(
          duration: Duration(seconds: 2),
          margin: EdgeInsets.symmetric(vertical: 6),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        print(this.id);
                        print(data["name"]);
                        print(data["id"]);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayMarket(
                              this.id,
                              data["id"],
                              data["shipping_time"],
                              data["name"],
                              this.token,
                              this.lat,
                              this.lng,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(7),
                              topLeft: Radius.circular(7)),
                          child: (data["photo"] == null)
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
                                  image:
                                      NetworkImage(data["photo"], scale: 1.0),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.9,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(4),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            data["name"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: nameSize,
                                              color: CustomColors.primary,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        IconButton(
                                          icon: FaIcon(
                                              FontAwesomeIcons.infoCircle),
                                          onPressed: () {
                                            posOfProducts.value =
                                                !posOfProducts.value;
                                          },
                                          iconSize: iconSize,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              posOfProducts.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "${AppLocale.of(context).getTranslated("delivery_cost")}  ${data["shipping_cost"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: smallNameSize),
                              )),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "${AppLocale.of(context).getTranslated("delivery_time")}  ${data["shipping_time"]}  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                            ),
                          ]),
                    )
                  : Container(),
              posOfProducts.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => StoreCommentsScreen(
                                        data["name"], data["id"]),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.solidComments,
                                    color: CustomColors.primary,
                                    size: smallIconSize,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "(${AppLocale.of(context).getTranslated("comments")} ${data["comments"]})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: smallNameSize,
                                      color: CustomColors.gray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: data["rate"].floorToDouble(),
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: smallIconSize,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: CustomColors.ratingBG,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
              posOfProducts.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.creditCard,
                                  color: CustomColors.primary,
                                  size: smallIconSize,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${AppLocale.of(context).getTranslated("delivery_method")} ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: smallNameSize,
                                    color: CustomColors.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(),
                        ],
                      ),
                    )
                  : Container(),
              data['coupon'] != null &&
                      data['coupon']['user_show'] != 0 &&
                      data['coupon']['status'] != 0
                  ? (posOfProducts.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.gift,
                                color: CustomColors.primary,
                                size: smallIconSize,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Text(
                                  "(${data['coupon']['coupon']}) ${AppLocale.of(context).getTranslated("discount")} ${data["coupondiscount"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")} ${AppLocale.of(context).getTranslated("discount_comp")} ${data['couponlimit']} ${AppLocale.of(context).getTranslated("discount_complete")} ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: smallNameSize,
                                      color: CustomColors.primary),
                                  overflow: TextOverflow.visible,
                                  maxLines: 4,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container())
                  : Container()
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "برجاء الانتظار...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              CircularProgressIndicator(
                backgroundColor: CustomColors.primary,
              ),
            ],
          ),
        ));
  }
}
