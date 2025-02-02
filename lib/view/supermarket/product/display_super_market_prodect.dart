import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/controller/Favorite/favorite_items_and_api.dart';
import 'package:matager/controller/cart/cart_bloc_off.dart';
import 'package:matager/utilities/lang/applocate.dart';

import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/supermarket/search/product_search_screen.dart';
import 'package:matager/view/user/cart/cart_offline.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/controller/store/home_api.dart';

import 'display_market_product_item_details.dart';

class DisplayMarketProduct extends StatefulWidget {
  int marketId, categoryId;
  String status;
  String categoryName;
  String marketName;
  String token;
  int position;

  double latitude, longitude;

  DisplayMarketProduct(
      this.marketId,
      this.categoryId,
      this.status,
      this.categoryName,
      this.marketName,
      this.token,
      this.latitude,
      this.longitude,
      this.position);

  @override
  _DisplayMarketProductState createState() => _DisplayMarketProductState();
}

class _DisplayMarketProductState extends State<DisplayMarketProduct>
    with TickerProviderStateMixin {
  MarketAndCategoryApi homePage;
  TabController tabController;

  int currentIndex = 0;
  ProductBloc bloc;

   final GlobalKey<ScaffoldState> _productScaffoldKey =
      new GlobalKey<ScaffoldState>();
  FavoriteMethodAPI favoriteMethodAPI;

  @override
  void initState() {
    bloc = ProductBloc(widget.marketId);
    homePage = MarketAndCategoryApi();
    favoriteMethodAPI = FavoriteMethodAPI();

    tabController =
        TabController(length: 0, vsync: this, initialIndex: widget.position);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: homePage.getSingleMarketSubcategory(
              widget.marketId, widget.categoryId),
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
                  List list = snapshot.data;
                  bloc.categoryIdSink.add(list[widget.position]["id"]);
                  tabController = TabController(
                      length: list.length,
                      vsync: this,
                      initialIndex: widget.position);

                  return _screen(list);
                } else
                  return emptyPage(context);

                break;
            }
            return emptyPage(context);
          }),
    );
  }

  Widget _screen(List<dynamic> data) {
    return Scaffold(
      key: _productScaffoldKey,
      drawer: NavDrawer(widget.latitude, widget.longitude),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.categoryName,
          style: TextStyle(
              color: CustomColors.whiteBG,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchScreen(widget.marketId, widget.status,
                    widget.token, widget.latitude, widget.longitude),
              );
            },
            icon: Icon(
              Icons.search,
            ),
          ),
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
                    onPressed: () {
                      print(widget.token);
                      if (widget.token == null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartOffLineScreen(
                                    widget.latitude, widget.longitude)));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartOnLineScreen(
                                    widget.latitude, widget.longitude)));
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
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: CustomColors.whiteBG,
          controller: tabController,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          labelPadding: EdgeInsets.only(left: 16, right: 16),
          unselectedLabelStyle: TextStyle(fontSize: 18),
          tabs: subCategoryTabs(data),
          isScrollable: true,
          onTap: (val) {
            widget.position = val;
            currentIndex = data[widget.position]["id"];
            bloc.categoryIdSink.add(currentIndex);
          },
        ),
      ),
      body: StreamBuilder(
          stream: bloc.productStream,
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
                          children:
                              List.generate(snapshot.data.length, (index) {
                            return _drawCardOfStore(snapshot.data[index]);
                          }),
                          childAspectRatio: .55,
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
                                Text(
                                  AppLocale.of(context)
                                      .getTranslated("product_dis"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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

  List<Tab> subCategoryTabs(List ListTabs) {
    List<Tab> tabs = [];
    for (var i in ListTabs) {
      tabs.add(Tab(
          text: AppLocale.of(context).getTranslated("lang") == "English"
              ? i['name']
              : i["name_en"]));
    }
    return tabs;
  }

  Widget _drawCardOfStore(Map data) {
    print(data);
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
                      data,
                      widget.marketId,
                      widget.status,
                      widget.token,
                      widget.latitude,
                      widget.longitude)));
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
                                            " ${data["oldprice"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                                            " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                                          color: CustomColors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                      widget.status == "غير متاح"
                          ? _drawStoreClose()
                          : _drawAddToCartButton(data, widget.token),
                    ],
                  ),
                ),
                data['offer']
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
                                  widget.marketId,
                                )
                                    .then((value) {
                                  final snackBar = SnackBar(
                                      backgroundColor:
                                          CustomColors.greenLightBG,
                                      content: Text(
                                        AppLocale.of(context)
                                                    .getTranslated("lang") ==
                                                'English'
                                            ? "مرحباُ : تم اضافه المنتج الي المفضلة ب نجاح.."
                                            : 'Hello: The product has been added to Favorite with success.. ',
                                        style: TextStyle(
                                            color: CustomColors.greenLightFont),
                                      ));
                                  _productScaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                });
                                favoriteNotifier.value = 1;
                              } else if (favoriteNotifier.value == 1) {
                                favoriteMethodAPI
                                    .removeFavorite(data["id"])
                                    .then((value) {
                                  final snackBar = SnackBar(
                                      backgroundColor:
                                          CustomColors.greenLightBG,
                                      content: Text(
                                        AppLocale.of(context)
                                                    .getTranslated("lang") ==
                                                'English'
                                            ? "مرحباُ : تم اضافه المنتج الي المفضلة ب نجاح.."
                                            : 'Hello: The product has been added to Favorite with success.. ',
                                        style: TextStyle(
                                            color: CustomColors.greenLightFont),
                                      ));
                                  _productScaffoldKey.currentState
                                      .showSnackBar(snackBar);
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
            widget.marketId,
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
          _productScaffoldKey.currentState.showSnackBar(snackBar);
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
            widget.marketId,
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

          _productScaffoldKey.currentState.showSnackBar(snackBar);
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .06,
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

  Widget _drawStoreClose() {
    return InkWell(
      //todo:add to cart offline or online
      onTap: () async {
        final snackBar = SnackBar(
            backgroundColor: CustomColors.ratingLightBG,
            content: Text(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "مرحباُ : ناسف هذا المتجر مغلق الان.."
                  : 'Hello: Sorry, this store is now closed..',
              style: TextStyle(color: CustomColors.ratingLightFont),
            ));

        _productScaffoldKey.currentState.showSnackBar(snackBar);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .06,
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
