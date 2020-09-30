import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/theme.dart';

class TabScreenOfOffer extends StatefulWidget {
  List map;

  TabScreenOfOffer(
    this.map,
  );

  @override
  _TabScreenOfOfferState createState() => _TabScreenOfOfferState();
}

class _TabScreenOfOfferState extends State<TabScreenOfOffer> {
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.6,
      child: InkWell(
        onTap: () {
//          Navigator.of(context)
//              .push(MaterialPageRoute(builder: (context) => screen));
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
                            color: Colors.red,
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
