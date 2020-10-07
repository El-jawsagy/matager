import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/store_comments.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'display_supermarket.dart';

class Markets extends StatefulWidget {
  int id;
  String name;
  double latitude, longitude;

  Markets(this.id, this.name, this.latitude, this.longitude);

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
    return Scaffold(
      backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name,
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
                return loading(context);
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, pos) {
                        Map map = snapshot.data[pos];
                        return snapshot.data.length >= 1
                            ? _drawCardOfStore(
                                map,
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          "assets/images/box.jpg",
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                        ),
                                      ),
                                      Text(
                                        AppLocale.of(context)
                                            .getTranslated("category_dis"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                    ),
                  );
                } else
                  return emptyPage(context);
                break;
            }
            return emptyPage(context);
          }),
    );
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
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayMarket(
                                widget.id,
                                data["name"],
                                data["id"],
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
                          SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {},
                              starCount: 5,
                              rating: double.parse(data["rate"].toString()),
                              size: 20.0,
                              isReadOnly: true,
                              filledIconData: Icons.star,
                              defaultIconData: Icons.star_border,
                              color: CustomColors.ratingBG,
                              borderColor: CustomColors.gray,
                              spacing: 0.0)
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
                                "${AppLocale.of(context).getTranslated("delivery_time")}  ${data["shipping_cost"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")} ",
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
}
