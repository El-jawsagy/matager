import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/search/store_search_screen.dart';
import 'package:matager/view/supermarket/store_comments.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/controller/store/home_api.dart';

import 'display_supermarket.dart';

class Markets extends StatefulWidget {
  int id;
  String name;
  String token;

  double latitude, longitude;

  Markets(this.id, this.name, this.token, this.latitude, this.longitude);

  @override
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  MarketAndCategoryApi homePage;

  @override
  void initState() {
    homePage = MarketAndCategoryApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    CategorySize categorySize = CategorySize(detectedScreen);
    return Scaffold(
      backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(
              fontSize: categorySize.headerTextSize,
              fontWeight: FontWeight.bold),
          textWidthBasis: TextWidthBasis.parent,
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: StoreSearchScreen(
                    widget.id, widget.latitude, widget.longitude, widget.token),
              );
            },
            icon: Icon(
              Icons.search,
              color: CustomColors.whiteBG,
              size: categorySize.iconHeaderSize,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: homePage.getSingleCategory(
              widget.id, widget.latitude, widget.longitude),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return emptyPage(context);
                break;
              case ConnectionState.waiting:
              case ConnectionState.active:
                return loading(context, 1);
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return snapshot.data.length >= 1
                      ? Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            itemBuilder: (context, pos) {
                              Map map = snapshot.data[pos];
                              return _drawCardOfStore(
                                  map,
                                  categorySize.nameSize,
                                  categorySize.iconSize,
                                  categorySize.smallNameSize,
                                  categorySize.smallIconSize);
                            },
                          ),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                ),
                                Text(
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "English"
                                      ? " لا يوجد متاجر ${widget.name} متاحة في منطقتك في الوقت الحالي "
                                      : "There are no ${widget.name} stores available in your area right now  ",
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
          }),
    );
  }

  Widget _drawCardOfStore(
      Map data, nameSize, iconSize, smallNameSize, smallIconSize) {
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
                        print(widget.id);
                        print(data["name"]);
                        print(data["id"]);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayMarket(
                                widget.id,
                                data["id"],
                                data["shipping_time"],
                                data["name"],
                                widget.token,
                                widget.latitude,
                                widget.longitude),
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
}
