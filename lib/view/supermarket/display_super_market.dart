import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/theme.dart';

import 'display_market_item.dart';

class DisplayMarket extends StatefulWidget {
  @override
  _DisplayMarketState createState() => _DisplayMarketState();
}

class _DisplayMarketState extends State<DisplayMarket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.whiteBG,
        elevation: 0,
        title: Text(
          "اسم المحل",
          style: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: CustomColors.dark),
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
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,

        // Generate 100 widgets that display their index in the List.
        children: List.generate(20, (index) {
          int price = Random().nextInt(100);
          return _drawCardOfStore("assets/images/super_market.jpg",
              DisplayMarketItem(price), price);
        }),
        childAspectRatio: .7,
      ),
    );
  }

  Widget _drawCardOfStore(String imagePath, var screen, int price) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.5,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => screen));
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .14,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        image: DecorationImage(
                            image: ExactAssetImage(imagePath),
                            fit: BoxFit.cover)),
                  ),
                  Text(
                    "اسم المنتج",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "نوع المنتج :",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "النوع ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    " ${price} جنية ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
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
          color: CustomColors.red,
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
