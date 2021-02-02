import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/orders_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/data/prefrences.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';

import '../../homepage.dart';
import 'order_details.dart';

class OrderScreen extends StatefulWidget {
  double latitude, longitude;

  OrderScreen(this.latitude, this.longitude);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

final GlobalKey<ScaffoldState> orderScaffoldKey =
    new GlobalKey<ScaffoldState>();

class _OrderScreenState extends State<OrderScreen> {
  OrdersApi ordersApi;

  @override
  void initState() {
    ordersApi = OrdersApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    OrderSize orderSize = OrderSize(detectedScreen);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: orderScaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocale.of(context).getTranslated("drawer_order"),
            style: TextStyle(
              color: CustomColors.whiteBG,
              fontSize: orderSize.headerTextSize,
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
                                          snapshot.data[index],
                                          orderSize.nameSize,
                                          orderSize.stringSize,
                                          orderSize.iconSize,
                                        );
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
                              ? "لم نستطع تحميل البيانات تفقد الانترنت"
                              : "we can't load data,check internet",
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

  Widget _drawCardOfStore(map, nameSize, stringSize, iconSize) {
    print(MediaQuery.of(context).size.width * 0.08);

    print(MediaQuery.of(context).size.height * 0.05);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
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
                              fontSize: nameSize,
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
                              fontSize: nameSize,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ),
                    _drawProductState(map["status"], stringSize, iconSize),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.of(context).getTranslated("lang") ==
                                  "English"
                              ? "اسم المتجر"
                              : "Store Name :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: nameSize,
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
                            fontSize: nameSize,
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
                          AppLocale.of(context).getTranslated("lang") ==
                                  "English"
                              ? "اجمالى السعر :"
                              : "Total Price :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: nameSize,
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
                            fontSize: nameSize,
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

  Widget _drawProductState(status, stringSize, iconSize) {
    Color firstColor;
    Color readyColor;
    Color onColor;
    switch (status) {
      case 0:
        firstColor = Colors.green;
        readyColor = Colors.grey;
        onColor = Colors.grey;
        break;
      case 1:
        firstColor = Colors.green;

        readyColor = Colors.green;
        onColor = Colors.grey;
        break;
      case 2:
        firstColor = Colors.green;

        readyColor = Colors.green;
        onColor = Colors.green;
        break;
      case 3:
        firstColor = Colors.red;

        readyColor = Colors.red;
        onColor = Colors.red;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.08,
                child: FaIcon(
                  FontAwesomeIcons.solidCheckCircle,
                  size: iconSize,
                  color: firstColor,
                ),
              ),
              Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "جارى تجهيز الطلب"
                    : " being processed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: stringSize,
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
            width: MediaQuery.of(context).size.width * 0.1,
            child: Divider(
              height: 7,
              color: readyColor,
            )),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.08,
                child: FaIcon(
                  FontAwesomeIcons.solidCheckCircle,
                  size: iconSize,
                  color: readyColor,
                ),
              ),
              Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "جارى توصيل الطلب"
                    : " being delivered",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: stringSize,
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
            width: MediaQuery.of(context).size.width * 0.1,
            child: Divider(
              height: 7,
              color: onColor,
            )),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.08,
                child: FaIcon(
                  FontAwesomeIcons.solidCheckCircle,
                  size: iconSize,
                  color: onColor,
                ),
              ),
              Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "تم استلام الطلب"
                    : " receipt order",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: stringSize,
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
