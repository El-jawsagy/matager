import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/theme.dart';

class DisplayMarketItem extends StatefulWidget {
  int price;

  DisplayMarketItem(this.price);

  @override
  _DisplayMarketItemState createState() => _DisplayMarketItemState();
}

class _DisplayMarketItemState extends State<DisplayMarketItem> {
  PageController _controller;
  TextEditingController _counterController;
  double pos;
  int counter;

  @override
  void initState() {
    pos = 1;
    counter = 0;
    _counterController = TextEditingController();
    _counterController.text = counter.toString();
    _controller =
        PageController(initialPage: pos.floor(), viewportFraction: 0.9);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.whiteBG,
        elevation: 0,
        title: Text(
          "اسم المنتج",
          style: TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: CustomColors.dark),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _drawItemImage("assets/images/super_market.jpg"),
          Align(
            alignment: Alignment.bottomCenter,
            child: DotsIndicator(
              dotsCount: 4,
              position: pos,
              decorator: DotsDecorator(
                color: Colors.grey,
                activeColor: Colors.red,
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
          _drawDescriptionText(),
          _drawItemDescription(
              "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها."),
          _drawCounterRow(counter),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _drawAddToCartButton(),
          )
        ],
      ),
    );
  }

  Widget _drawItemImage(String imagePath) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .3,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (val) {
              setState(() {
                pos = val.floorToDouble();
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                        image: ExactAssetImage(imagePath), fit: BoxFit.cover)),
              );
            },
            itemCount: 4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  " ${widget.price} جنية ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _drawDescriptionText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 24, right: 24, top: 8),
          width: MediaQuery.of(context).size.width,
          child: Text(
            AppLocale.of(context).getTranslated("details"),
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ],
    );
  }

  Widget _drawItemDescription(String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          width: MediaQuery.of(context).size.width,
          child: Text(
            description,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _drawCounterRow(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              highlightColor: Colors.red,
              iconSize: 36,
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  counter++;
                  _counterController.text = counter.toString();
                });
              }),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10),
            width: MediaQuery.of(context).size.width * 0.5,
            child: EditableText(
              controller: _counterController,
              backgroundCursorColor: Colors.black,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              focusNode: FocusNode(),
              onChanged: (val) {
                setState(() {
                  counter = int.parse(_counterController.text);
                });
              },
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
              highlightColor: Colors.red,
              iconSize: 36,
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (counter >= 1) {
                    counter--;
                  }
                  _counterController.text = counter.toString();
                });
              }),
        ],
      ),
    );
  }

  Widget _drawAddToCartButton() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .08,
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
      child: InkWell(
        onTap: () async {},
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                AppLocale.of(context).getTranslated("add_cart"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.shopping_cart,
                color: CustomColors.whiteBG,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
