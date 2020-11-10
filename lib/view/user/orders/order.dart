import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/orders_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/prefrences.dart';
import 'package:matager/view/utilities/theme.dart';

import '../../homepage.dart';
import 'order_details.dart';

class OrderScreen extends StatefulWidget {
  double latitude, longitude;

  OrderScreen(this.latitude, this.longitude);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrdersApi ordersApi;

  @override
  void initState() {
    ordersApi = OrdersApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocale.of(context).getTranslated("drawer_order"),
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
        body: FutureBuilder(
          future: Preference.getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                  future: ordersApi.getOrdersItems(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return emptyPage(context);
                        break;
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return loading(context, 1);
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          print(snapshot.data);

                          return snapshot.data.length > 0
                              ? Stack(
                                  children: [
                                    ListView.builder(
                                      itemBuilder: (context, index) {
                                        return _drawCardOfStore(
                                            snapshot.data[index]);
                                      },
                                      itemCount: snapshot.data.length,
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    AppLocale.of(context)
                                                .getTranslated("lang") ==
                                            'English'
                                        ? "لم تقم بطلب أي عنصر حتى الآن"
                                        : "You don't order any item yet",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                );
                        }
                        return Center(
                            child: Text(
                          AppLocale.of(context).getTranslated("lang") ==
                                  'English'
                              ? "لم تختار أي عنصر حتى الآن"
                              : "You haven't taken any item yet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ));
                        break;
                    }
                    return emptyPage(context);
                  });
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      AppLocale.of(context).getTranslated("apology"),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen(
                                          widget.latitude, widget.longitude)));
                            },
                            child: Text(
                              AppLocale.of(context).getTranslated("log"),
                              style: TextStyle(
                                color: CustomColors.whiteBG,
                              ),
                            ),
                            color: CustomColors.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _drawCardOfStore(
    map,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      height: MediaQuery.of(context).size.height * 0.23,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(
                      map, widget.latitude, widget.longitude)));
        },
        child: Stack(
          children: <Widget>[
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.22,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.of(context).getTranslated("lang") ==
                                    'English'
                                ? "رقم الفاتورة :"
                                : "bill number :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primary,
                              fontSize: 22,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            map["id"].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.gray,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    _drawProductState(map["status"]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "اسم المتجر :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: CustomColors.primary,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          map["storename"],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "اجمالى السعر :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: CustomColors.primary,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          " ${map["total_price"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                          style: new TextStyle(
                            fontSize: 16,
                            color: CustomColors.primary,
                          ),
                        ),
                      ],
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

  Widget _drawProductState(status) {
    Color readyColor;
    Color onColor;
    switch (status) {
      case 0:
        readyColor = Colors.grey;
        onColor = Colors.grey;
        break;
      case 1:
        readyColor = Colors.green;
        onColor = Colors.grey;
        break;
      case 2:
        readyColor = Colors.green;
        onColor = Colors.green;
        break;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 25,
                width: 25,
                child: FaIcon(
                  FontAwesomeIcons.solidCheckCircle,
                  size: 22,
                  color: Colors.green,
                ),
              ),
              Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "جارى تجهيز الطلب"
                    : "The order is being processed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
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
            width: 65,
            child: Divider(
              height: 7,
              color: readyColor,
            )),
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 25,
                width: 25,
                child: FaIcon(
                  FontAwesomeIcons.solidCheckCircle,
                  size: 22,
                  color: readyColor,
                ),
              ),
              Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "جارى توصيل الطلب"
                    : "The order is being delivered",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
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
            width: 65,
            child: Divider(
              height: 7,
              color: onColor,
            )),
        Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 25,
                width: 25,
                child: FaIcon(
                  FontAwesomeIcons.solidCheckCircle,
                  size: 22,
                  color: onColor,
                ),
              ),
              Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "تم استلام الطلب"
                    : "The receipt of the order",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
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
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
