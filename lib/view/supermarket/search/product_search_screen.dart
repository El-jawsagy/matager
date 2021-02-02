import 'package:flutter/material.dart';
import 'package:matager/controller/cart/cart_bloc_off.dart';
import 'package:matager/controller/store/search_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/supermarket/product/display_market_product_item_details.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';

class ProductSearchScreen extends SearchDelegate {
  int id;
  String status;
  String token;
  double lat, lng;

  ProductSearchScreen(this.id, this.status, this.token, this.lat, this.lng);

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
        headline3: TextStyle(color: CustomColors.whiteBG),
      ),
    );
  }

  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => 'Search for product';

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
    return FutureBuilder(
        future: searchProductsAndStoresApi.getProducts(
          query,
          this.id,
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
                    ? GridView.count(
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 2,

                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(snapshot.data.length, (index) {
                    return _drawCardOfStore(
                        context, snapshot.data[index]);
                  }),
                  childAspectRatio: .55,
                )
                    : Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/images/box.jpg",
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.25,
                            ),
                          ),
                          Text(
                            AppLocale.of(context).getTranslated("prod_dis"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
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

  Widget _drawCardOfStore(BuildContext context, Map data) {
    print(data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery
          .of(context)
          .size
          .width * 0.4,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.6,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  DisplayMarketItemDetails(
                      data, this.id, this.status, this.token, this.lat,
                      this.lng)));
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
                            topRight: Radius.circular(7)),
                        child: (data["image"] == null)
                            ? Image.asset(
                          "assets/images/boxImage.png",
                        )
                            : Image(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * .2,
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
                      Text(
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? data["name_ar"]
                            : data["name_en"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                      Text.rich(
                        data['offer']
                            ? TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                              " ${data["oldprice"]} ${AppLocale.of(context)
                                  .getTranslated("delivery_cost_unit")}",
                              style: new TextStyle(
                                color: CustomColors.red,
                                decoration: TextDecoration.lineThrough,
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
                              " ${data["price"]} ${AppLocale.of(context)
                                  .getTranslated("delivery_cost_unit")}",
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
                              " ${data["price"]} ${AppLocale.of(context)
                                  .getTranslated("delivery_cost_unit")}",
                              style: new TextStyle(
                                color: CustomColors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  this.status == "غير متاح"
                      ? _drawStoreClose(context)
                      : _drawAddToCartButton(context, data, this.token),
                ],
              ),
            ),
            data['offer'] == 1
                ? Opacity(
              opacity: 0.75,
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
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _drawAddToCartButton(BuildContext context, Map data, String token) {
    return InkWell(
      //todo:add to cart offline or online

      onTap: () async {
        if (token == null) {
          var quant;
          if (data['unit'] == "0") {
            quant = 1.0;
          } else {
            quant = .25;
          }
          itemBlocOffLine.addToCart(
            data,
            quant,
            this.id,
            double.tryParse(data['price']),
          );
          final snackBar = SnackBar(
              backgroundColor: CustomColors.greenLightBG,
              content: Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "مرحباُ : تم اضافه المنتج الي سله المشتريات ب نجاح.."
                    : 'Hello: The product has been added to the cart with success.. ',
                style: TextStyle(color: CustomColors.greenLightFont),
              ));

          Scaffold.of(context).showSnackBar(snackBar);
        } else {
          var quant;
          if (data['unit'] == "0") {
            quant = 1.0;
          } else {
            quant = .25;
          }
          itemBlocOnLineN.addToCart(
            data,
            quant,
            this.id,
            double.tryParse(data['price']),
          );

          final snackBar = SnackBar(
              backgroundColor: CustomColors.greenLightBG,
              content: Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "مرحباُ : تم اضافه المنتج الي سله المشتريات ب نجاح.."
                    : 'Hello: The product has been added to the cart with success.. ',
                style: TextStyle(color: CustomColors.greenLightFont),
              ));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * .06,
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
          borderRadius: BorderRadius.circular(5),
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

  Widget _drawStoreClose(BuildContext context,) {
    return InkWell(
      //todo:add to cart offline or online
      onTap: () async {
        final snackBar = SnackBar(
            backgroundColor: CustomColors.ratingLightBG,
            content: Text(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "..مرحباُ : ناسف هذا المتجر مغلق الان"
                  : 'Hello: Sorry, this store is now closed ..',
              style: TextStyle(color: CustomColors.ratingLightFont),
            ));

        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * .06,
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
          borderRadius: BorderRadius.circular(5),
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
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }
}
