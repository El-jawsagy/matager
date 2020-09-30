import 'package:flutter/material.dart';
import 'package:matager/controller/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/view/supermarket/offer/screen_of_offer.dart';

import 'product/screen_of_proudect.dart';

class DisplayMarket extends StatefulWidget {
  int categoryID;
  int marketId;
  String marketName;

  DisplayMarket(this.categoryID, this.marketName, this.marketId);

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
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: CustomColors.whiteBG,
              ),
            ),
            IconButton(
              onPressed: () {},
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
                  return loading(context);
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<Widget> TabsHomePage = [
                      TabScreenoFCategory(
                        snapshot.data["categories"],
                        widget.marketId,
                      ),
                      TabScreenOfOffer(snapshot.data["offers"]),
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
