import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/store/search_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/theme.dart';

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
  }

  Widget _drawCardOfStore(Map data) {
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
                                this.lng),
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
                                        Text(
                                          data["name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: CustomColors.primary,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.infoCircle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FlatButton(
                                    color: CustomColors.primary,
                                    child: Text(
                                      AppLocale.of(context)
                                          .getTranslated("more_det"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.whiteBG),
                                    ),
                                    onPressed: () {
                                      posOfProducts.value =
                                          !posOfProducts.value;
                                    })
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
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "(${AppLocale.of(context).getTranslated("comments")} ${data["comments"]})",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
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
                            initialRating: data["rate"],
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 20.0,
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
                          children: <Widget>[
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
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "${AppLocale.of(context).getTranslated("delivery_cost")}  ${data["shipping_cost"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                            ),
                          ]),
                    )
                  : Container(),
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
