import 'package:flutter/material.dart';
import 'package:matager/controller/Favorite/favorite_items_and_api.dart';
import 'package:matager/controller/cart/cart_bloc_off.dart';
import 'package:matager/controller/cart/cart_items_bloc_and_Api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/supermarket/product/display_market_product_item_details.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabScreenOfOffer extends StatefulWidget {
  List map;
  String marketName;
  int subMarketId;
  String token;

  double latitude, longitude;

  TabScreenOfOffer(this.map, this.subMarketId, this.marketName, this.token,
      this.latitude, this.longitude);

  @override
  _TabScreenOfOfferState createState() => _TabScreenOfOfferState();
}

class _TabScreenOfOfferState extends State<TabScreenOfOffer> {
  CardMethodApi cardMethodApi;
  FavoriteMethodAPI favoriteMethodAPI;

  @override
  void initState() {
    cardMethodApi = CardMethodApi();
    favoriteMethodAPI = FavoriteMethodAPI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.map.length >= 1
        ? GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,

            // Generate 100 widgets that display their index in the List.
            children: List.generate(widget.map.length, (index) {
              return _drawCardOfStore(
                widget.map[index],
              );
            }),
            childAspectRatio: .6,
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    "assets/images/box.jpg",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                Text(
                  AppLocale.of(context).getTranslated("offer_dis"),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
  }

  Widget _drawCardOfStore(Map data) {
    ValueNotifier<int> favoriteNotifier;
    favoriteNotifier = ValueNotifier(data["favourite"]);

    return ValueListenableBuilder(
      valueListenable: favoriteNotifier,
      builder: (BuildContext context, int value, Widget child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 6),
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.6,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DisplayMarketItemDetails(
                      data, widget.token, widget.latitude, widget.longitude)));
            },
            child: Stack(
              children: <Widget>[
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(7),
                              topRight: Radius.circular(7),
                            ),
                            child: (data["image"] == null)
                                ? Image.asset(
                                    "assets/images/boxImage.png",
                                  )
                                : Image(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.height * .2,
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
                                        NetworkImage(data["image"], scale: 1.0),
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          Text(
                            AppLocale.of(context).getTranslated("lang") ==
                                    'English'
                                ? data["name_ar"]
                                : data["name_en"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          Text.rich(
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                  style: new TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                TextSpan(
                                  text: " ",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                new TextSpan(
                                  text:
                                      " ${data["offer_price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                  style: new TextStyle(
                                    color: CustomColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _drawAddToCartButton(data, widget.token),
                    ],
                  ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: Container(
                    width: 50,
                    height: 25,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: CustomColors.primary,
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                        child: Text(
                      " ${data["discount"]} %",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 50,
                      height: 25,
                      margin: EdgeInsets.all(12),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            favoriteNotifier.value == 0
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: Colors.black,
                          ),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var token = prefs.getString("token");
                            if (token == null) {
                              Navigator.pop(context);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                          widget.latitude, widget.longitude)));
                            } else {
                              if (favoriteNotifier.value == 0) {
                                favoriteMethodAPI
                                    .addToFavorite(
                                  data['id'],
                                  widget.subMarketId,
                                )
                                    .then((value) {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Product added to your favorites list'),
                                    duration: Duration(seconds: 3),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });

                                favoriteNotifier.value == 1;
                              } else if (favoriteNotifier.value == 1) {
                                favoriteMethodAPI
                                    .removeFavorite(data["id"])
                                    .then((value) {
                                  final snackBar = SnackBar(
                                    content: Text(
                                        'Product removed from your favorites list'),
                                    duration: Duration(seconds: 3),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                });
                                favoriteNotifier.value == 1;
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _drawAddToCartButton(Map data, String token) {
    return InkWell(
      onTap: () async {
        if (token == null) {
          var quant;
          if (data['unit'] == "0") {
            quant = 1.0;
          } else {
            quant = .25;
          }
          itemBlocOffLine.addToCart(
              data, quant, widget.subMarketId, double.tryParse(data['price']));
          final snackBar = SnackBar(
            content: Text('thanks for your order'),
            duration: Duration(seconds: 3),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        } else {
          var quant;
          if (data['unit'] == "0") {
            quant = 1.0;
          } else {
            quant = .25;
          }
          itemBlocOnLineN.addToCart(
              data, quant, widget.subMarketId, double.tryParse(data['price']));

          final snackBar = SnackBar(
            content: Text('thanks for your order'),
            duration: Duration(seconds: 3),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .04,
        decoration: BoxDecoration(
          color: CustomColors.primary,
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
              Icon(
                Icons.shopping_cart,
                color: CustomColors.whiteBG,
              ),
              Text(
                AppLocale.of(context).getTranslated("add_cart"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
