import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/cart/cart_bloc_online.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../homepage.dart';
import 'cart_check_out.dart';

CartItemsBlocOn itemBlocOnLineN = CartItemsBlocOn();

class CartOnLineScreen extends StatefulWidget {
  double latitude, longitude;

  CartOnLineScreen(this.latitude, this.longitude);

  @override
  _CartOnLineScreenState createState() => _CartOnLineScreenState();
}

class _CartOnLineScreenState extends State<CartOnLineScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  Map allItems = {
    'cart_items': [],
  };

  @override
  void initState() {
    itemBlocOnLineN.setToCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocale.of(context).getTranslated("drawer_cart"),
            style: TextStyle(
              color: CustomColors.whiteBG,
              fontSize: 22,
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
                  AppLocale.of(context).getTranslated("lang") == 'English'
                      ? "لم تختار أي عنصر حتى الآن"
                      : "You haven't taken any item yet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ));
                break;
              case ConnectionState.waiting:
                print("i'm here waiting");
                return loading(context, 1);

                break;
              case ConnectionState.active:
              case ConnectionState.done:
                print("i'm here done");

                if (snapshot.hasData) {
                  allItems = snapshot.data;

                  return snapshot.data['cart_items'].length > 0
                      ? Stack(
                          children: [
                            ListView.builder(
                              itemBuilder: (context, index) {
                                return _drawCardOfStore(
                                    snapshot.data['cart_items'][index]);
                              },
                              itemCount: snapshot.data['cart_items'].length,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _drawCompleteOrder(snapshot.data['cart_items']),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                          AppLocale.of(context).getTranslated("lang") == 'English'
                              ? "لم تختار أي عنصر حتى الآن"
                              : "You haven't taken any item yet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ));
                }
                return Center(
                    child: Text(
                  AppLocale.of(context).getTranslated("lang") == 'English'
                      ? "لم تختار أي عنصر حتى الآن"
                      : "You haven't taken any item yet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ));
                break;
            }
            return Center(
                child: Text(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "لم تختار أي عنصر حتى الآن"
                  : "You haven't taken any item yet",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ));
          },
        ),
      ),
    );
  }

  Widget _drawCardOfStore(
    map,
  ) {
    Map data = map["data"];
    double quan = map['quantity'];

    ValueNotifier<double> posOfProducts = ValueNotifier(quan);
    TextEditingController counterController = TextEditingController();
    counterController.text = posOfProducts.value.toString();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      height: MediaQuery.of(context).size.height * 0.15,
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
                  width: 50,
                  height: 50,
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
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      AppLocale.of(context).getTranslated("lang") == 'English'
                          ? data["name_ar"]
                          : data["name_en"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
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
                                              " ${data["price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.red,
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
                                              " ${(double.tryParse(data["offer_price"]) * posOfProducts.value).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.primary,
                                          ),
                                        ),
                                      ],
                                    )
                                  : TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " ${(double.tryParse(data["price"]) * posOfProducts.value).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    _drawCounterRow(data, posOfProducts, counterController),
                  ],
                ),
                _drawRemoveButton(
                  map,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawCounterRow(Map data, ValueNotifier<double> posOfProducts,
      TextEditingController counterController) {
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                    highlightColor: Colors.red,
                    iconSize: 20,
                    icon: Icon(Icons.add),
                    onPressed: () {
                      counterController.text = posOfProducts.value.toString();
                      itemBlocOnLineN.increaseQuantity(
                          data, posOfProducts.value);
                    }),
                Container(
                  padding: EdgeInsets.only(left: 2, right: 2, top: 2),
                  width: MediaQuery.of(context).size.width * 0.12,
                  child: EditableText(
                    controller: counterController,
                    backgroundCursorColor: Colors.black,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
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
                        iconSize: 20,
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
                        iconSize: 20,
                        icon: Icon(
                          Icons.remove,
                          color: CustomColors.darkOne,
                          size: 20,
                        ),
                        onPressed: () {})
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawRemoveButton(Map data) {
    return InkWell(
      onTap: () async {
        itemBlocOnLineN.removeFromCart(
          data,
        );
        final snackBar = SnackBar(
          content: Text('order remove from your card'),
          duration: Duration(seconds: 3),
        );
        _scaffoldkey.currentState.showSnackBar(snackBar);
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
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawCompleteOrder(List products) {
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
            height: MediaQuery.of(context).size.height * .055,
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
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
  @override
  void dispose() {
    itemBlocOnLineN.upgradeUserCart();
    super.dispose();
  }
}
