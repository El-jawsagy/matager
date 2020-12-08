import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/cart/cart_bloc_online.dart';
import 'package:matager/controller/cart/cart_items_bloc_and_Api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_check_out.dart';

CartItemsBlocOn itemBlocOnLineN = CartItemsBlocOn();

class CartOnLineScreen extends StatefulWidget {
  double latitude, longitude;

  CartOnLineScreen(
    this.latitude,
    this.longitude,
  );

  @override
  _CartOnLineScreenState createState() => _CartOnLineScreenState();
}

class _CartOnLineScreenState extends State<CartOnLineScreen> {
   final GlobalKey<ScaffoldState> _cartOsScaffoldKey = new GlobalKey<ScaffoldState>();
  Map allItems = {
    'cart_items': [],
  };
  ValueNotifier<double> totalPrice;
  ValueNotifier<bool> valueOfCoupon;

  CardMethodApi cardMethodApi;
  int couponId, couponDiscount;

  @override
  void initState() {
    itemBlocOnLineN.setToCart();
    valueOfCoupon = ValueNotifier(false);
    cardMethodApi = CardMethodApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    CartSize cartSize = CartSize(detectedScreen);
    totalPrice = ValueNotifier(0);
    return Scaffold(
      key: _cartOsScaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("drawer_cart"),
          style: TextStyle(
            color: CustomColors.whiteBG,
            fontSize: cartSize.headerTextSize,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      drawer: NavDrawer(widget.latitude, widget.longitude),
      body: StreamBuilder(
        stream: itemBlocOnLineN.getStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                  child: Text(
                    AppLocale.of(context).getTranslated("lang") ==
                        'English'
                        ? "لم نستطع تحميل البيانات تفقد الانترنت"
                        : "we can't load data,check internet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ));
              break;
            case ConnectionState.waiting:
              return loading(context, 1);

              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                allItems = snapshot.data;

                return snapshot.data['cart_items'].length > 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _drawCardOfStore(
                                    snapshot.data['cart_items'][index],
                                    cartSize.nameSize,
                                    cartSize.priceSize,
                                    cartSize.iconSize);
                              },
                              itemCount: snapshot.data['cart_items'].length,
                            ),
                            _drawTotalPrice(snapshot.data['cart_items']),
                            SizedBox(
                              height: cartSize.sizeBoxHeight / 2,
                            ),
                            _drawCompleteOrder(
                                snapshot.data['cart_items'], cartSize.nameSize),
                            SizedBox(
                              height: cartSize.sizeBoxHeight,
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? "لم تختار أي عنصر حتى الآن"
                            : "You haven't taken any item yet",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: cartSize.headerTextSize,
                        ),
                      ));
              }
              return Center(
                  child: Text(
                    AppLocale.of(context).getTranslated("lang") ==
                        'English'
                        ? "لم نستطع تحميل البيانات تفقد الانترنت"
                        : "we can't load data,check internet",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ));
              break;
          }
          return Center(
              child: Text(
                AppLocale.of(context).getTranslated("lang") ==
                    'English'
                    ? "لم نستطع تحميل البيانات تفقد الانترنت"
                    : "we can't load data,check internet",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ));
        },
      ),
    );
  }

  Widget _drawCardOfStore(map, nameSize, priceSize, iconSize) {
    Map data = map["data"];
    double quan = map['quantity'];
    ValueNotifier<double> posOfProducts = ValueNotifier(quan);
    TextEditingController counterController = TextEditingController();
    counterController.text = posOfProducts.value.toString();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    child: (data["image"] == null)
                        ? Image.asset(
                            "assets/images/boxImage.png",
                          )
                        : Image(
                            width: MediaQuery.of(context).size.width,
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
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? data["name_ar"]
                            : data["name_en"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: nameSize,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.035,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ValueListenableBuilder(
                        valueListenable: posOfProducts,
                        builder:
                            (BuildContext context, double value, Widget child) {
                          return Center(
                            child: Text.rich(
                              data['offer']
                                  ? TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " ${data["oldprice"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.red,
                                            fontSize: priceSize,
                                            decoration:
                                                TextDecoration.lineThrough,
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
                                              " ${double.tryParse(data["price"]).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.primary,
                                            fontSize: priceSize,
                                          ),
                                        ),
                                      ],
                                    )
                                  : TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " ${double.tryParse(data["price"]).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.red,
                                            fontSize: priceSize,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    _drawCounterRow(data, posOfProducts, counterController,
                        iconSize, nameSize),
                  ],
                ),
                _drawRemoveButton(map, iconSize),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawCounterRow(Map data, ValueNotifier<double> posOfProducts,
      TextEditingController counterController, iconSize, nameSize) {
    var fixed;
    if (data["unit"] == "0") {
      fixed = 1;
    } else {
      fixed = 0.25;
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ValueListenableBuilder(
        valueListenable: posOfProducts,
        builder: (BuildContext context, double value, Widget child) {
          print(iconSize);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    highlightColor: Colors.red,
                    iconSize: iconSize,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      counterController.text = posOfProducts.value.toString();
                      itemBlocOnLineN.increaseQuantity(
                          data, posOfProducts.value);
                    }),
                Container(
                  padding: EdgeInsets.only(left: 2, right: 2, top: 2),
                  width: MediaQuery.of(context).size.width * 0.13,
                  child: EditableText(
                    controller: counterController,
                    backgroundCursorColor: Colors.black,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: nameSize,
                        fontWeight: FontWeight.bold),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    focusNode: FocusNode(),
                    onChanged: (val) {
                      posOfProducts.value = double.parse(val);
                      itemBlocOnLineN.increaseQuantity(
                          data, posOfProducts.value);
                    },
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                  ),
                ),
                posOfProducts.value > fixed
                    ? IconButton(
                        highlightColor: Colors.red,
                        iconSize: iconSize,
                        icon: Icon(Icons.remove, color: CustomColors.dark),
                        onPressed: () {
                          if (posOfProducts.value > 0) {
                            counterController.text =
                                posOfProducts.value.toString();
                            itemBlocOnLineN.decreaseQuantity(
                                data, posOfProducts.value);
                          }
                        })
                    : IconButton(
                        highlightColor: Colors.grey,
                        iconSize: iconSize,
                        icon: Icon(
                          Icons.remove,
                          color: CustomColors.darkOne,
                          size: iconSize,
                        ),
                        onPressed: () {})
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawRemoveButton(Map data, iconSize) {
    return InkWell(
      onTap: () async {
        itemBlocOnLineN.removeFromCart(
          data,
        );
        final snackBar = SnackBar(
            backgroundColor: CustomColors.greenLightBG,
            content: Text(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "مرحباُ : تم ازالة المنتج من سله المشتريات ب نجاح.."
                  : "Hello: The product has been removed from the cart with success ..",
              style: TextStyle(color: CustomColors.greenLightFont),
            ));

        _cartOsScaffoldKey.currentState.showSnackBar(snackBar);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .09,
          height: MediaQuery.of(context).size.height * .04,
          decoration: BoxDecoration(
            color: CustomColors.gray,
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
                FaIcon(
                  FontAwesomeIcons.trash,
                  color: CustomColors.whiteBG,
                  size: iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawTotalPrice(list) {
    totalPrice.value = 0;
    for (var i in list) {
      totalPrice.value = (totalPrice.value + i["new_price"]);
    }
    return ValueListenableBuilder(
      valueListenable: totalPrice,
      builder: (BuildContext context, double value, Widget child) {
        return Container(
          decoration: BoxDecoration(color: CustomColors.whiteBG, boxShadow: [
            BoxShadow(
              color: CustomColors.gray,
              blurRadius: 0.7,
            )
          ]),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocale.of(context).getTranslated("total"),
                        style: TextStyle(
                            fontSize: 16, color: CustomColors.grayOne),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        totalPrice.value.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _drawCompleteOrder(List products, nameSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var token = prefs.getString("token");
            if (token == null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(widget.latitude, widget.longitude)));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartCheckOut(
                          widget.latitude, widget.longitude, products)));
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * .55,
            height: MediaQuery.of(context).size.height * .065,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomColors.primary,
                CustomColors.primary,
              ]),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.whiteBG,
                  blurRadius: .75,
                  spreadRadius: .75,
                  offset: Offset(0.0, 0.0),
                )
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                AppLocale.of(context).getTranslated("complete_order"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: nameSize,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
