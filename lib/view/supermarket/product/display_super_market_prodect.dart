import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/controller/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

import 'display_market_product_item_details.dart';

class DisplayMarketProduct extends StatefulWidget {
  int storeId, categoryId;
  String categoryName;

  DisplayMarketProduct(this.storeId, this.categoryId, this.categoryName);

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
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.categoryName,
          style: TextStyle(
              color: CustomColors.whiteBG,
              fontSize: 26,
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
                          childAspectRatio: .6,
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
              builder: (context) => DisplayMarketItemDetails(data)));
        },
        child: Stack(
          children: <Widget>[
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
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
                            fit: BoxFit.cover,
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
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                                  color: CustomColors.gray,
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
                                  color: CustomColors.red,
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
                  _drawAddToCartButton(),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 25,
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(7)),
              child: Center(
                  child: Text(
                " ${Random().nextInt(100)} %",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawAddToCartButton() {
    return InkWell(
      onTap: () async {},
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
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
              Text(
                AppLocale.of(context).getTranslated("add_cart"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.shopping_cart,
                color: CustomColors.whiteBG,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
