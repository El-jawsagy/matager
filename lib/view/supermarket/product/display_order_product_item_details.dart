import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:matager/controller/cart/cart_bloc_off.dart';
import 'package:matager/controller/store/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/user/cart/cart_offline.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayOrderItemDetails extends StatefulWidget {
  String productId;
  String storeName;

  double latitude, longitude;

  DisplayOrderItemDetails(
    this.productId,
    this.storeName,
    this.latitude,
    this.longitude,
  );

  @override
  _DisplayOrderItemDetailsState createState() =>
      _DisplayOrderItemDetailsState();
}

class _DisplayOrderItemDetailsState extends State<DisplayOrderItemDetails> {
  PageController _controller;
  TextEditingController _counterController;
  double pos;
  ValueNotifier<double> posOfProducts;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  MarketAndCategoryApi marketAndCategoryApi = MarketAndCategoryApi();

  @override
  void initState() {
    posOfProducts = ValueNotifier(1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.storeName,
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
            onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();

              if (pref.get("token") == null) {
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
      ),
      body: FutureBuilder(
          future: marketAndCategoryApi.getSingleProduct(widget.productId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return emptyPage(context);
                break;
              case ConnectionState.waiting:

              case ConnectionState.active:
                return loading(context, 0.2);
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  print(data);
                  pos = 0;
                  data["unit"] == "0"
                      ? posOfProducts = ValueNotifier(1)
                      : posOfProducts = ValueNotifier(0.25);
                  _counterController = TextEditingController();
                  _counterController.text = posOfProducts.value.toString();
                  _controller = PageController(
                    initialPage: pos.floor(),
                  );
                  return ListView(
                    children: <Widget>[
                      _drawItemImage(data['images']),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: DotsIndicator(
                          dotsCount: data['images'].length,
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
                          AppLocale.of(context).getTranslated("lang") ==
                                  'English'
                              ? data["name_ar"]
                              : data["name_en"],
                          style: TextStyle(
                            color: CustomColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 22, right: 22, top: 10, bottom: 10),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[300],
                        ),
                      ),
                      _drawItemDescription(data),
                      _drawPrice(data),
                      _drawCounterRow(data, posOfProducts.value),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _drawAddToCartButton(
                          data,
                          posOfProducts,
                        ),
                      )
                    ],
                  );
                } else
                  return emptyPage(context);
                break;
            }
            return emptyPage(context);
          }),
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

  Widget _drawPrice(data) {
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
            data['offer']
                ? TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                            " ${data["offer_price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                        style: new TextStyle(
                            color: CustomColors.primary, fontSize: 24),
                      ),
                    ],
                  )
                : TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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

  Widget _drawDescriptionText(data) {
    return (data["content_ar"] == null && data["content_en"] == null)
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

  Widget _drawItemDescription(data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10),
          width: MediaQuery.of(context).size.width,
          child: Html(
            data: AppLocale.of(context).getTranslated("lang") == 'English'
                ? (data["content_ar"] == null ? "" : data["content_ar"])
                : (data["content_en"] == null ? "" : data["content_en"]),
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

  Widget _drawCounterRow(data, double count) {
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
                    posOfProducts.value = data["unit"] == "0"
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
                          posOfProducts.value = data["unit"] == "0"
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

  Widget _drawAddToCartButton(
    data,
    ValueNotifier<double> quantity,
  ) {
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
        //todo:add to cart offline or online
        onTap: () async {
          if (quantity.value == 0) {
            final snackBar = SnackBar(
              content: Text("Sorry put you can't add 0 quantity of product "),
              duration: Duration(seconds: 3),
            );
            _scaffoldkey.currentState.showSnackBar(snackBar);
          } else {
            SharedPreferences pref = await SharedPreferences.getInstance();

            if (pref.get("token") == null) {
              itemBlocOffLine.addToCart(data, quantity.value, widget.productId,
                  double.tryParse(data["price"]));
              final snackBar = SnackBar(
                content: Text('thanks for your order'),
                duration: Duration(seconds: 3),
              );
              _scaffoldkey.currentState.showSnackBar(snackBar);
            } else {
              print(quantity.value);
              itemBlocOnLineN.addToCart(data, quantity.value, data["store_id"],
                  double.tryParse(data["price"]));

              final snackBar = SnackBar(
                content: Text('thanks for your order'),
                duration: Duration(seconds: 3),
              );
              _scaffoldkey.currentState.showSnackBar(snackBar);
            }
          }
        },
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
