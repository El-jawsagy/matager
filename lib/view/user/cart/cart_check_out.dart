import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/address_api.dart';
import 'package:matager/controller/cart/cart_items_bloc_and_Api.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/controller/orders.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/user/address/setAddress.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

class CartCheckOut extends StatefulWidget {
  double latitude, longitude;
  List data;

  CartCheckOut(this.latitude, this.longitude, this.data);

  @override
  _CartCheckOutState createState() => _CartCheckOutState();
}

class _CartCheckOutState extends State<CartCheckOut> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  AddressAPI addressAPI;
  CardMethodApi cardMethodApi;
  OrdersApi ordersApi;
  ValueNotifier<int> _groupValue;
  ValueNotifier<int> _addressId;

  @override
  void initState() {
    addressAPI = AddressAPI();
    cardMethodApi = CardMethodApi();
    ordersApi = OrdersApi();
    _groupValue = ValueNotifier(0);
    _addressId = ValueNotifier(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: CustomColors.grayTow,
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
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
                                        data["sub_total"].toString(),
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
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
                                        data["total_shipping"].toString(),
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
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
                                        data["total"].toString(),
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
              width: MediaQuery.of(context).size.width * .1,
              height: MediaQuery.of(context).size.height * .035,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  CustomColors.primary,
                  CustomColors.primary,
                ]),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: IconButton(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
      height: MediaQuery.of(context).size.height * 0.13,
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
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.03,
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
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Center(
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
                                              " ${(double.tryParse(data["offer_price"])).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                      height: MediaQuery.of(context).size.height * 0.04,
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
                          Text(
                            data["store_name"],
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawOrderButton(double textButtonSize) {
    return InkWell(
      onTap: () async {
        ordersApi
            .makeOrder(widget.data, _addressId.value, null, null)
            .then((value) {
          if (value == "true") {
            final snackBar = SnackBar(
              content: Text('thanks for your order'),
              duration: Duration(seconds: 3),
            );
            _scaffoldkey.currentState.showSnackBar(snackBar);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else {
            final snackBar = SnackBar(
              content: Text(
                  'sorry your order is not complete please check internet and try again'),
              duration: Duration(seconds: 3),
            );
            _scaffoldkey.currentState.showSnackBar(snackBar);
          }
        });
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
