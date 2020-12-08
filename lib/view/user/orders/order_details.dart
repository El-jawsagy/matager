import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/orders_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/product/display_order_product_item_details.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/theme.dart';

class OrderDetailsScreen extends StatefulWidget {
  double latitude, longitude;
  Map data;

  OrderDetailsScreen(this.data, this.latitude, this.longitude);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrdersApi ordersApi;
  final GlobalKey<ScaffoldState> orderScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    ordersApi = OrdersApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    OrderDetailsSize orderDetailsSize = OrderDetailsSize(detectedScreen);
    return Scaffold(
      key: orderScaffoldKey,
      backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("order_details"),
          style: TextStyle(
            color: CustomColors.whiteBG,
            fontSize: orderDetailsSize.headerTextSize,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.of(context).getTranslated("lang") == 'English'
                            ? "رقم ألطلب #"
                            : "order number #",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.primary,
                          fontSize: orderDetailsSize.nameSize,
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
                        widget.data["id"].toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.gray,
                          fontSize: orderDetailsSize.nameSize,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                  if (widget.data["status"] == 2)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff3898FF))),
                        child: InkWell(
                          onTap: showMaterialDialog,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocale.of(context).getTranslated("lang") ==
                                        'English'
                                    ? "تقييم المتجر"
                                    : "Store Rating",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff3898FF),
                                  fontSize: orderDetailsSize.nameSize,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                              FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: Color(0xff3898FF),
                                size: orderDetailsSize.iconSize,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    Container(),
                ],
              ),
            ),
            _drawHeadrLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "بيانات المشترى :"
                  : "Customer's data :",
              FontAwesomeIcons.info,
              orderDetailsSize.nameSize,
              orderDetailsSize.iconSize,
            ),
            _drawBodyItemLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "الاسم بالكامل :"
                  : "full name :",
              widget.data["user"]['name'].toString(),
              1,
              FontAwesomeIcons.userAlt,
              orderDetailsSize.nameSize,
              orderDetailsSize.iconSize,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FaIcon(
                    FontAwesomeIcons.mapMarkerAlt,
                    color: CustomColors.dark,
                    size: orderDetailsSize.iconSize,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  widget.data["address"] == null
                      ? Container()
                      : Text(
                          AppLocale.of(context).getTranslated("lang") ==
                                  'English'
                              ? " عنوان التوصيل :"
                              : "Delivery Address :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: CustomColors.dark,
                            fontSize: orderDetailsSize.nameSize,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                  widget.data["address"] == null
                      ? Container()
                      : SizedBox(
                          width: 5,
                        ),
                  widget.data["address"] == null
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            widget.data["address"] == null
                                ? ""
                                : widget.data["address_details"],
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: CustomColors.dark,
                              fontSize: orderDetailsSize.nameSize,
                            ),
                            maxLines: 3,
                          ),
                        ),
                ],
              ),
            ),
            widget.data["address"] == null
                ? Container()
                : _drawBodyItemLine(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? " رقم الموبيل :"
                        : "mobile number :",
                    widget.data["address"] == null
                        ? ""
                        : widget.data["address"]['phone'].toString(),
                    1,
                    FontAwesomeIcons.mobileAlt,
                    orderDetailsSize.nameSize,
                    orderDetailsSize.iconSize,
                  ),
            widget.data["address"] == null
                ? Container()
                : _drawBodyItemLine(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? "رقم الهاتف الارضى :"
                        : "telephone phone number :",
                    widget.data["address"] == null
                        ? ""
                        : widget.data["address"]['telephone'].toString(),
                    1,
                    FontAwesomeIcons.phone,
                    orderDetailsSize.nameSize,
                    orderDetailsSize.iconSize,
                  ),
            widget.data["address"] == null
                ? Container()
                : _drawBodyItemLine(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? "المدينة :"
                        : "city :",
                    widget.data["address"] == null
                        ? ""
                        : widget.data["address"]['city'].toString(),
                    1,
                    FontAwesomeIcons.home,
                    orderDetailsSize.nameSize,
                    orderDetailsSize.iconSize,
                  ),
            widget.data["address"] == null
                ? Container()
                : _drawBodyItemLine(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? "المنطقة :"
                        : "region :",
                    widget.data["address"] == null
                        ? ""
                        : widget.data["address"]['region'].toString(),
                    1,
                    FontAwesomeIcons.home,
                    orderDetailsSize.nameSize,
                    orderDetailsSize.iconSize,
                  ),
            _drawHeadrLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "بيانات المتجر :"
                  : "Store data :",
              FontAwesomeIcons.info,
              orderDetailsSize.nameSize,
              orderDetailsSize.iconSize,
            ),
            _drawBodyItemLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "اسم المتجر :"
                  : "Store name :",
              widget.data['storename'].toString(),
              1,
              FontAwesomeIcons.userAlt,
              orderDetailsSize.nameSize,
              orderDetailsSize.iconSize,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.creditCard,
                    color: CustomColors.primary,
                    size: orderDetailsSize.iconSize,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? " طريقة الدفع : "
                        : "Payment method :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primary,
                      fontSize: orderDetailsSize.nameSize,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      AppLocale.of(context).getTranslated("lang") == 'English'
                          ? "  الدفع كاش عند الاستلام"
                          : "Payment is cash upon receipt",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: CustomColors.dark,
                        fontSize: orderDetailsSize.nameSize,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.calendarDay,
                    color: CustomColors.primary,
                    size: orderDetailsSize.iconSize,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? " تاريخ الطلب : "
                        : "The date of the Order :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primary,
                      fontSize: orderDetailsSize.nameSize,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      widget.data["created_at"],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: CustomColors.dark,
                        fontSize: orderDetailsSize.nameSize,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (BuildContext context, int index) {
                return _drawCardOfStore(
                    widget.data["products_id"][index],
                    widget.data["store_id"],
                    widget.data["shipping_time"],
                    widget.data["products_images"][index],
                    widget.data["products_names"][index],
                    widget.data["quantities"][index],
                    widget.data["prices"][index],
                    widget.data["storename"],
                    orderDetailsSize.nameSize);
              },
              itemCount: widget.data["products_id"].length,
            ),
            _drawPrice(orderDetailsSize.nameSize),
          ],
        ),
      ),
    );
  }

  Widget _drawHeadrLine(
    String type,
    IconData iconData,
    iconSize,
    nameSize,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FaIcon(
            iconData,
            color: CustomColors.primary,
            size: iconSize,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            type,
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
        ],
      ),
    );
  }

  Widget _drawBodyItemLine(
    String title,
    value,
    int lines,
    IconData iconData,
    nameSize,
    iconSize,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
              iconData,
              color: CustomColors.dark,
              size: iconSize,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.dark,
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
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: CustomColors.dark,
                  fontSize: nameSize,
                ),
                maxLines: lines,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawCardOfStore(id, storeId, shippingTime, image, name, quantity,
      price, storeName, nameSize) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayOrderItemDetails(id, storeId,
                    shippingTime, storeName, widget.latitude, widget.longitude),
              ));
        },
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
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                      child: (image == null)
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
                              image: NetworkImage(image, scale: 1.0),
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: nameSize,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocale.of(context)
                                      .getTranslated("quantity"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: nameSize,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  quantity,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: nameSize,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Center(
                              child: Text.rich(
                                TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          " ${price.toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
                                      style: new TextStyle(
                                        color: CustomColors.red,
                                        fontSize: nameSize,
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
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocale.of(context).getTranslated("seller"),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: nameSize,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                storeName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: nameSize,
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
      ),
    );
  }

  Widget _drawPrice(nameSize) {
    print(widget.data["coupon_id"]);

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
                    AppLocale.of(context).getTranslated("sub_total"),
                    style: TextStyle(
                        fontSize: nameSize, color: CustomColors.grayOne),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.data["coupon_id"] == null
                        ? "${(double.tryParse(widget.data["total_price"]) - widget.data["shipping_cost"]).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}"
                        : "${((double.tryParse(widget.data["total_price"]) + widget.data["coupon_disc"]) - widget.data["shipping_cost"]).toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
            ),
            widget.data["coupon_id"] != null
                ? Container(
                    padding: const EdgeInsets.all(2),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocale.of(context).getTranslated("cart_discount"),
                          style: TextStyle(
                              fontSize: nameSize,
                              color: CustomColors.greenLightFont),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.data["coupon_disc"].toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.all(2),
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.of(context).getTranslated("shipping_cost"),
                    style: TextStyle(
                        fontSize: nameSize, color: CustomColors.grayOne),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.data["shipping_cost"].toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
            ),
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
                        fontSize: nameSize, color: CustomColors.grayOne),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${widget.data["total_price"].toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
            )
          ],
        ),
      ),
    );
  }

  showMaterialDialog() {
    TextEditingController massageController = TextEditingController();
    ValueNotifier<double> count = ValueNotifier(0);
    ValueNotifier<bool> state = ValueNotifier(false);

    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(AppLocale.of(context).getTranslated("lang") == "English"
            ? "قم بتقييم المتجر"
            : "Rate the store"),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RatingBar.builder(
                      itemSize: 30,
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: CustomColors.ratingBG,
                      ),
                      onRatingUpdate: (rating) {
                        count.value = rating;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextFormField(
                  controller: massageController,
                  autofocus: false,
                  onChanged: (value) {},
                  maxLines: 10,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    hintText:
                        AppLocale.of(context).getTranslated("lang") == "English"
                            ? "اكتب تعليقك"
                            : "Write your comment",
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              FlatButton(
                child: Text(
                    AppLocale.of(context).getTranslated("lang") == "English"
                        ? "تراجع"
                        : "Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ValueListenableBuilder(
                valueListenable: state,
                builder: (BuildContext context, value, Widget child) {
                  return Container(
                    child: state.value
                        ? Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomColors.primary),
                              ),
                            ),
                          )
                        : FlatButton(
                            child: Text(
                                AppLocale.of(context).getTranslated("send")),
                            onPressed: () {
                              state.value = true;
                              if (massageController.text.isNotEmpty ||
                                  count.value > 0) {
                                ordersApi
                                    .rattingOrder(widget.data["store_id"],
                                        massageController.text, count.value)
                                    .then((value) {
                                  state.value = false;

                                  if (value['data'] == "true") {
                                    Navigator.pop(context);
                                    final snackBar = SnackBar(
                                        backgroundColor:
                                            CustomColors.greenLightBG,
                                        content: Text(
                                          AppLocale.of(context)
                                                      .getTranslated("lang") ==
                                                  'English'
                                              ? "تم اضافه التعليق ."
                                              : "Comment added.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  CustomColors.greenLightFont),
                                        ));

                                    orderScaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  } else {
                                    Navigator.pop(context);

                                    final snackBar = SnackBar(
                                        backgroundColor:
                                            CustomColors.ratingLightBG,
                                        content: Text(
                                          AppLocale.of(context)
                                                      .getTranslated("lang") ==
                                                  'English'
                                              ? "حدث خطأ من فضلك تاكد من الاتصال بالانترنت وحاول مرة اخري"
                                              : "An error occurred. Please check your internet connection and try again",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  CustomColors.ratingLightFont),
                                        ));

                                    orderScaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                });
                              } else {
                                Navigator.pop(context);
                                final snackBar = SnackBar(
                                    backgroundColor: CustomColors.ratingLightBG,
                                    content: Text(
                                      AppLocale.of(context)
                                                  .getTranslated("lang") ==
                                              'English'
                                          ? "لا يمكنك ارسال تقييم لا يحتوي علي بيانات"
                                          : "You cannot submit an evaluation that does not contain data",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: CustomColors.ratingLightFont),
                                    ));

                                orderScaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
