import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/search/product_search_screen.dart';
import 'package:matager/view/user/cart/cart_offline.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/controller/store/home_api.dart';

import 'offer/screen_of_offer.dart';
import 'product/screen_of_proudect.dart';

class DisplayMarket extends StatefulWidget {
  int categoryID;
  int marketId;
  String marketName;
  String token;
  double latitude, longitude;

  DisplayMarket(this.categoryID, this.marketId, this.marketName, this.token,
      this.latitude, this.longitude);

  @override
  _DisplayMarketState createState() => _DisplayMarketState();
}

class _DisplayMarketState extends State<DisplayMarket> {
  MarketAndCategoryApi homePage;

  @override
  void initState() {
    homePage = MarketAndCategoryApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CustomColors.whiteBG,
        drawer: NavDrawer(widget.latitude, widget.longitude),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.marketName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textWidthBasis: TextWidthBasis.parent,
          ),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: ProductSearchScreen(widget.marketId, widget.token,
                      widget.latitude, widget.longitude),
                );
              },
              icon: Icon(
                Icons.search,
                color: CustomColors.whiteBG,
              ),
            ),
            IconButton(
              onPressed: () {
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
                color: CustomColors.whiteBG,
              ),
            ),
          ],
          bottom: TabBar(
            indicator: BoxDecoration(
              color: CustomColors.darkOne,
            ),
            tabs: <Widget>[
              Tab(
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocale.of(context).getTranslated("Category"),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocale.of(context).getTranslated("offer"),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder(
            future: homePage.getSingleMarket(widget.marketId),
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
                    List<Widget> TabsHomePage = [
                      TabScreenoFCategory(
                          snapshot.data["categories"],
                          widget.marketId,
                          widget.marketName,
                          widget.token,
                          widget.latitude,
                          widget.longitude),
                      TabScreenOfOffer(
                        snapshot.data["offers"],
                        widget.marketId,
                        widget.marketName,
                        widget.token,
                        widget.latitude,
                        widget.longitude,
                      ),
                    ];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(children: TabsHomePage),
                    );
                  } else
                    return emptyPage(context);
                  break;
              }
              return emptyPage(context);
            }),
      ),
    );
  }
}
