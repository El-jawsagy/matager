import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/address_api.dart';
import 'package:matager/controller/cart/cart_items_bloc_and_Api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/user/address/setAddress.dart';
import 'package:matager/view/user/orders/order.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/controller/orders_api.dart';

class CartCheckOut extends StatefulWidget {
  double latitude, longitude;
  List data;

  CartCheckOut(this.latitude, this.longitude, this.data);

  @override
  _CartCheckOutState createState() => _CartCheckOutState();
}

class _CartCheckOutState extends State<CartCheckOut> {
  static final GlobalKey<ScaffoldState> _cartPayScaffoldKey =
      new GlobalKey<ScaffoldState>();
  AddressAPI addressAPI;
  CardMethodApi cardMethodApi;
  OrdersApi ordersApi;
  ValueNotifier<int> _groupValue;
  ValueNotifier<int> _addressId;
  ValueNotifier<int> _couponID;
  ValueNotifier<int> _couponDiscount;
  ValueNotifier<bool> valueOfCoupon;

  final _couponKey = GlobalKey<FormState>();
  TextEditingController _couponTextController = TextEditingController();

  @override
  void initState() {
    addressAPI = AddressAPI();
    cardMethodApi = CardMethodApi();
    ordersApi = OrdersApi();

    _groupValue = ValueNotifier(0);
    _addressId = ValueNotifier(0);
    _couponDiscount = ValueNotifier(0);
    _couponID = ValueNotifier(0);
    valueOfCoupon = ValueNotifier(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    CartCheckOutSize cartCheckOutSize = CartCheckOutSize(detectedScreen);
    return Scaffold(
      key: _cartPayScaffoldKey,
      backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("complete_order"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _drawTextAddress(),
            FutureBuilder(
                future: addressAPI.getUserAddress(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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

                        if (snapshot.data.length > 0) {
                          return Container(
                            color: Colors.white,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                var item = data[index];
                                print(data[index]);
                                if (item["default"] == 1) {
                                  _groupValue.value = index;
                                  _addressId.value = item["id"];
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: _myRadioButton(
                                      title: item['full_address'],
                                      RadioButtonValue: index,
                                      onChanged: (newValue) {
                                        _groupValue.value = newValue;
                                        _addressId.value = item["id"];
                                      },
                                      posOfProducts: _groupValue),
                                );
                              },
                              itemCount: data.length,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocale.of(context)
                                      .getTranslated("Address_dis"),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: CustomColors.dark),
                                ),
                              ],
                            ),
                          );
                        }
                      } else
                        return emptyPage(context);
                      break;
                  }
                  return emptyPage(context);
                }),
            _drawTextProducts("shipping"),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (BuildContext context, int index) {
                var item = widget.data[index];
                print(widget.data[index]);
                return _drawCardOfStore(item);
              },
              itemCount: widget.data.length,
            ),
            ValueListenableBuilder(
              valueListenable: _couponDiscount,
              builder: (BuildContext context, value, Widget child) {
                return _couponDiscount.value > 0
                    ? _drawDisplayCoupon(_couponDiscount.value)
                    : _drawEnterCoupon();
              },
            ),
            _drawTextProducts("total"),
            FutureBuilder(
                future: cardMethodApi.getCartPrice(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        print("the price ids$data");

                        return ValueListenableBuilder(
                          valueListenable: _couponDiscount,
                          builder: (BuildContext context, value, Widget child) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: CustomColors.whiteBG,
                                  boxShadow: [
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
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocale.of(context)
                                                .getTranslated("sub_total"),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: CustomColors.grayOne),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${data["sub_total"].toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocale.of(context)
                                                .getTranslated("shipping_cost"),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: CustomColors.grayOne),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "${data["total_shipping"].toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                                    ),
                                    _couponDiscount.value > 0
                                        ? Container(
                                            padding: const EdgeInsets.all(2),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  AppLocale.of(context)
                                                      .getTranslated(
                                                          "cart_discount"),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: CustomColors
                                                          .greenLightFont),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "${_couponDiscount.value.toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocale.of(context)
                                                .getTranslated("total"),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: CustomColors.grayOne),
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            " ${(data["total"] - _couponDiscount.value).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                      } else
                        return emptyPage(context);
                      break;
                  }
                  return emptyPage(context);
                }),
            _drawOrderButton(18),
          ],
        ),
      ),
    );
  }

  Widget _drawTextAddress() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocale.of(context).getTranslated("address"),
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.primary),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  CustomColors.primary,
                  CustomColors.primary,
                ]),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Row(
                  children: [
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.plus,
                        size: 12,
                        color: CustomColors.whiteBG,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAddressScreen(
                                    widget.latitude, widget.longitude)));
                      },
                    ),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.trash,
                        size: 12,
                        color: CustomColors.whiteBG,
                      ),
                      onPressed: () {
                        addressAPI
                            .removeAddress(_addressId.value)
                            .then((value) {
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myRadioButton({
    String title,
    int RadioButtonValue,
    Function onChanged,
    ValueNotifier<int> posOfProducts,
  }) {
    return ValueListenableBuilder(
      valueListenable: posOfProducts,
      builder: (BuildContext context, value, Widget child) {
        return RadioListTile(
          value: RadioButtonValue,
          activeColor: CustomColors.primary,
          groupValue: posOfProducts.value,
          onChanged: onChanged,
          title: Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CustomColors.darkBlue),
          ),
        );
      },
    );
  }

  Widget _drawTextProducts(string) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            AppLocale.of(context).getTranslated(string),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CustomColors.primary),
          ),
        ],
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
      margin: EdgeInsets.symmetric(vertical: 2),
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? data["name_ar"]
                            : data["name_en"],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocale.of(context).getTranslated("quantity"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                posOfProducts.value.toString(),
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
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
                            child: Text.rich(
                              data['offer']
                                  ? TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " ${data["oldprice"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                                        TextSpan(
                                          text:
                                              " ${(double.tryParse(data["price"])).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: TextStyle(
                                            color: CustomColors.primary,
                                          ),
                                        ),
                                      ],
                                    )
                                  : TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " ${(double.tryParse(data["price"])).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                          style: new TextStyle(
                                            color: CustomColors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocale.of(context).getTranslated("seller"),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              data["store_name"],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawEnterCoupon() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        valueListenable: valueOfCoupon,
        builder: (BuildContext context, value, Widget child) {
          return valueOfCoupon.value
              ? Container(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _couponKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          keyboardType: TextInputType.multiline,
                          controller: _couponTextController,
                          decoration: InputDecoration(
                            hintText:
                                AppLocale.of(context).getTranslated("lang") ==
                                        'English'
                                    ? "ادخل كوبون الخصم"
                                    : "Enter the discount coupon",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            fillColor: CustomColors.dark,
                          ),
                          validator: (onValue) {
                            if (onValue.isEmpty) {
                              return AppLocale.of(context)
                                  .getTranslated("wrong");
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: InkWell(
                        onTap: () {
                          if (_couponKey.currentState.validate()) {
                            cardMethodApi
                                .checkCoupon(
                              _couponTextController.text,
                            )
                                .then((value) {
                              if (value['data'] == "false") {
                                final snackBar = SnackBar(
                                    backgroundColor: CustomColors.ratingLightBG,
                                    content: Text(
                                      AppLocale.of(context)
                                                  .getTranslated("lang") ==
                                              'English'
                                          ? "الكوبون الذي ادخلته غير صالح"
                                          : "coupon you entered is not valid",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.ratingLightFont),
                                    ));

                                _cartPayScaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              } else if (value['data'] == "wrong limit") {
                                final snackBar = SnackBar(
                                    backgroundColor: CustomColors.ratingLightBG,
                                    content: Text(
                                      AppLocale.of(context)
                                                  .getTranslated("lang") ==
                                              'English'
                                          ? "الكوبون الذي ادخلته لم يصل بعد لقيمة المشتريات المحددة"
                                          : "The coupon you entered has not yet reached the value of the specified purchases",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.ratingLightFont),
                                    ));

                                _cartPayScaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              } else if (value['data'].containsKey("id")) {
                                _couponDiscount.value =
                                    value['data']["discount"];
                                _couponID.value = value['data']["id"];
                              }
                            });
                          }
                        },
                        child: Text(
                          AppLocale.of(context).getTranslated("send"),
                          style: TextStyle(
                            color: CustomColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
              : FlatButton(
                  padding: EdgeInsets.all(8),
                  color: CustomColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? "هل لديك قسيمة ؟"
                        : 'Have coupon ?',
                    style: TextStyle(
                      color: CustomColors.whiteBG,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    valueOfCoupon.value = !valueOfCoupon.value;
                  },
                );
        },
      ),
    );
  }

  Widget _drawDisplayCoupon(coupon) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListTile(
            title: Text(
              _couponTextController.text,
              style: TextStyle(
                color: CustomColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: FaIcon(FontAwesomeIcons.times),
              onPressed: () {
                _couponDiscount.value = 0;
                _couponTextController.text = '';
              },
            ),
          ),
        ));
  }

  Widget _drawOrderButton(double textButtonSize) {
    return InkWell(
      onTap: () async {
        ordersApi
            .makeOrder(widget.data, _addressId.value, _couponID.value,
                _couponDiscount.value)
            .then((value) {
          if (value == "true") {
            final snackBar = SnackBar(
              backgroundColor: CustomColors.greenLightBG,
              content: Text(
                AppLocale.of(context).getTranslated("lang") == "English"
                    ? "تم ارسال طلبك بنجاح .."
                    : "Your order has been sent successfully ..",
                style: TextStyle(color: CustomColors.greenLightFont),
              ),
              duration: Duration(seconds: 3),
            );
            orderScaffoldKey.currentState.showSnackBar(snackBar);
            countOfProducts.value = 0;
          } else {
            final snackBar = SnackBar(
              backgroundColor: CustomColors.ratingLightBG,
              content: Text(
                AppLocale.of(context).getTranslated("lang") == "English"
                    ? "آسف لم يكتمل طلبك ، يرجى التحقق من الإنترنت والمحاولة مرة أخرى"
                    : 'sorry your order is not complete please check internet and try again',
                style: TextStyle(color: CustomColors.redLightFont),
              ),
              duration: Duration(seconds: 3),
            );
            orderScaffoldKey.currentState.showSnackBar(snackBar);
          }
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderScreen(widget.latitude, widget.longitude)));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .97,
          height: MediaQuery.of(context).size.height * .07,
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
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(
            child: Text(
              AppLocale.of(context).getTranslated("order"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textButtonSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
