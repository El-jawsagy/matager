import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/theme.dart';

class DisplayMarketItemDetails extends StatefulWidget {
  Map map;
  String marketName;
  double latitude, longitude;

  DisplayMarketItemDetails(
      this.map, this.marketName, this.latitude, this.longitude);

  @override
  _DisplayMarketItemDetailsState createState() =>
      _DisplayMarketItemDetailsState();
}

class _DisplayMarketItemDetailsState extends State<DisplayMarketItemDetails> {
  PageController _controller;
  TextEditingController _counterController;
  double pos;
  ValueNotifier<double> posOfProducts;

  @override
  void initState() {
    pos = 0;
    widget.map["unit"] == "0"
        ? posOfProducts = ValueNotifier(1)
        : posOfProducts = ValueNotifier(0.25);
    _counterController = TextEditingController();
    _counterController.text = posOfProducts.value.toString();
    _controller = PageController(
      initialPage: pos.floor(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(widget.latitude, widget.longitude),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.marketName,
          style: TextStyle(
            color: CustomColors.whiteBG,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
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
          _drawItemImage(widget.map['images']),
          Align(
            alignment: Alignment.bottomCenter,
            child: DotsIndicator(
              dotsCount: widget.map['images'].length,
              position: pos,
              decorator: DotsDecorator(
                color: Colors.grey,
                activeColor: CustomColors.primary,
                size: const Size.square(10.0),
                activeSize: const Size(20.0, 10.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Text(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? widget.map["name_ar"]
                  : widget.map["name_en"],
              style: TextStyle(
                color: CustomColors.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 10),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          _drawItemDescription(),
          _drawPrice(),
          _drawCounterRow(posOfProducts.value),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _drawAddToCartButton(),
          )
        ],
      ),
    );
  }

  Widget _drawItemImage(List imagePath) {
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
                padding: EdgeInsets.only(top: 8, left: 4, right: 4),
                child: (imagePath[index] == null)
                    ? Image.asset(
                        "assets/images/boxImage.png",
                      )
                    : Image(
                        loadingBuilder:
                            (context, image, ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            return image;
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        image: NetworkImage(
                          imagePath[index],
                        ),
                        fit: BoxFit.contain,
                      ),
              );
            },
            itemCount: imagePath.length,
          ),
        ),
      ],
    );
  }

  Widget _drawPrice() {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocale.of(context).getTranslated("price"),
            style: TextStyle(
                color: CustomColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          SizedBox(
            width: 5,
          ),
          Text.rich(
            widget.map['offer']
                ? TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " ${widget.map["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                        style: new TextStyle(
                            color: CustomColors.red,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 18),
                      ),
                      TextSpan(
                        text: " ",
                      ),
                      new TextSpan(
                        text:
                            " ${widget.map["offer_price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                        style: new TextStyle(
                            color: CustomColors.primary, fontSize: 24),
                      ),
                    ],
                  )
                : TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " ${widget.map["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                        style: new TextStyle(
                            color: CustomColors.red, fontSize: 24),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _drawDescriptionText() {
    return (widget.map["content_ar"] == null &&
            widget.map["content_en"] == null)
        ? Container()
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  AppLocale.of(context).getTranslated("details"),
                  style: TextStyle(
                      color: CustomColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            ],
          );
  }

  Widget _drawItemDescription() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          width: MediaQuery.of(context).size.width,
          child: Html(
            data: AppLocale.of(context).getTranslated("lang") == 'English'
                ? (widget.map["content_ar"] == null
                    ? ""
                    : widget.map["content_ar"])
                : (widget.map["content_en"] == null
                    ? ""
                    : widget.map["content_en"]),
            //Optional parameters:
            style: {
              "div": Style(
                  fontSize: FontSize(20),
                  textDecorationStyle: TextDecorationStyle.double,
                  fontWeight: FontWeight.w600),
              "p": Style(
                  fontSize: FontSize(18),
                  textDecorationStyle: TextDecorationStyle.double,
                  fontWeight: FontWeight.w600),
            },
          ),
        ),
      ],
    );
  }

  Widget _drawCounterRow(double count) {
    return ValueListenableBuilder(
      valueListenable: posOfProducts,
      builder: (BuildContext context, double value, Widget child) {
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
                    posOfProducts.value = widget.map["unit"] == "0"
                        ? posOfProducts.value + 1
                        : (posOfProducts.value + .25);

                    _counterController.text = posOfProducts.value.toString();
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
                    posOfProducts.value = double.parse(val);
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                ),
              ),
              posOfProducts.value > 0
                  ? IconButton(
                      highlightColor: Colors.red,
                      iconSize: 36,
                      icon: Icon(Icons.remove, color: CustomColors.dark),
                      onPressed: () {
                        if (posOfProducts.value > 0) {
                          posOfProducts.value = widget.map["unit"] == "0"
                              ? posOfProducts.value - 1
                              : (posOfProducts.value - .25);

                          _counterController.text =
                              posOfProducts.value.toString();
                        }
                      })
                  : Icon(
                      Icons.remove,
                      color: CustomColors.darkOne,
                      size: 36,
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _drawAddToCartButton() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * .8,
      height: MediaQuery.of(context).size.height * .1,
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
      child: InkWell(
        onTap: () async {},
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                color: CustomColors.whiteBG,
                size: 30,
              ),
              Text(
                AppLocale.of(context).getTranslated("add_cart"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
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
}
