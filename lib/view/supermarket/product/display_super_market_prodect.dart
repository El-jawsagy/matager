import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/controller/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'display_market_product_item_details.dart';

class DisplayMarketProduct extends StatefulWidget {
  int storeId, categoryId;
  String categoryName;
  String marketName;
  double latitude, longitude;

  DisplayMarketProduct(this.storeId, this.categoryId, this.categoryName,
      this.marketName, this.latitude, this.longitude);

  @override
  _DisplayMarketProductState createState() => _DisplayMarketProductState();
}

class _DisplayMarketProductState extends State<DisplayMarketProduct>
    with TickerProviderStateMixin {
  MarketAndCategoryApi homePage;
  TabController tabController;
  int currentIndex = 0;
  ProductBloc bloc;

  @override
  void initState() {
    bloc = ProductBloc(widget.storeId);
    homePage = MarketAndCategoryApi();
    tabController = TabController(length: 0, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: homePage.getSingleMarketSubcategory(
              widget.storeId, widget.categoryId),
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
                print(snapshot.data);
                print(snapshot.data.length);
                if (snapshot.hasData) {
                  List list = snapshot.data;
                  bloc.categoryIdSink.add(list[0]["id"]);
                  tabController = TabController(
                      length: list.length, vsync: this, initialIndex: 0);

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
          )
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
          onTap: (int val) {
            currentIndex = data[val]["id"];
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
                return loading(context);
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
      tabs.add(Tab(text: i['name']));
    }
    return tabs;
  }

  Widget _drawCardOfStore(Map data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.6,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DisplayMarketItemDetails(
                  data, widget.marketName, widget.latitude, widget.longitude)));
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
                                        " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                                        " ${data["offer_price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                  _drawAddToCartButton(),
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
                        Icons.favorite_border,
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
                                  builder: (context) => LoginScreen(widget.latitude, widget.longitude)));
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
  }

  Widget _drawAddToCartButton() {
    return InkWell(
      onTap: () async {},
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
}
