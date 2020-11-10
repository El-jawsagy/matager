import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/product/display_order_product_item_details.dart';
import 'package:matager/view/utilities/theme.dart';

class OrderDetailsScreen extends StatefulWidget {
  double latitude, longitude;
  Map data;

  OrderDetailsScreen(this.data, this.latitude, this.longitude);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("this is ${widget.data}");

    return Scaffold(backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("order_details"),
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
                        widget.data["id"].toString(),
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
                  if (widget.data["status"] == 0)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff3898FF))),
                        child: InkWell(
                          // onTap: ,
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
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),

                              FaIcon(
                                FontAwesomeIcons.solidStar,
                                color: Color(0xff3898FF),
                                size: 16,
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
                FontAwesomeIcons.info),
            _drawBodyItemLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "الاسم بالكامل :"
                  : "full name :",
              widget.data["user"]['name'].toString(),
              1,
              FontAwesomeIcons.userAlt,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FaIcon(
                    FontAwesomeIcons.mapMarkerAlt,
                    color: CustomColors.dark,
                    size: 14,
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? " عنوان التوصيل :"
                        : "Delivery Address :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.dark,
                      fontSize: 18,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Text(
                      widget.data["address_details"],
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: CustomColors.dark,
                        fontSize: 16,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
            _drawBodyItemLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? " رقم الموبيل :"
                  : "mobile number :",
              widget.data["address"]['phone'].toString(),
              1,
              FontAwesomeIcons.mobileAlt,
            ),
            _drawBodyItemLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "رقم الهاتف الارضى :"
                  : "telephone phone number :",
              widget.data["address"]['telephone'].toString(),
              1,
              FontAwesomeIcons.phone,
            ),
            _drawBodyItemLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "المدينة :"
                  : "city :",
              widget.data["address"]['city'].toString(),
              1,
              FontAwesomeIcons.home,
            ),
            _drawHeadrLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "بيانات المتجر :"
                  : "Store data :",
              FontAwesomeIcons.info,
            ),
            _drawBodyItemLine(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "اسم المتجر :"
                  : "Store name :",
              widget.data['storename'].toString(),
              1,
              FontAwesomeIcons.userAlt,
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
                    size: 14,
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
                      fontSize: 18,
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
                        fontSize: 16,
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
                    size: 14,
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
                      fontSize: 16,
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
                        fontSize: 14,
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
                    widget.data["products_images"][index],
                    widget.data["products_names"][index],
                    widget.data["quantities"][index],
                    widget.data["prices"][index],
                    widget.data["storename"]);
              },
              itemCount: widget.data["products_id"].length,
            ),
            _drawPrice(),
          ],
        ),
      ),
    );
  }

  Widget _drawHeadrLine(String type, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FaIcon(
            iconData,
            color: CustomColors.primary,
            size: 14,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            type,
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
        ],
      ),
    );
  }

  Widget _drawBodyItemLine(String title, value, int lines, IconData iconData) {
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
              size: 14,
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CustomColors.dark,
                fontSize: 18,
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
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: CustomColors.dark,
                  fontSize: 16,
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

  Widget _drawCardOfStore(
    id,
    image,
    name,
    quantity,
    price,
    storeName,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      height: MediaQuery.of(context).size.height * 0.13,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayOrderItemDetails(
                    id, storeName, widget.latitude, widget.longitude),
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
                      Text(
                        name,
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
                                  AppLocale.of(context)
                                      .getTranslated("quantity"),
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
                                  quantity,
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
                                TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          " ${price.toString()} ${AppLocale.of(context).getTranslated("delivery_cost_unit")}",
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
                              storeName,
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
      ),
    );
  }

  Widget _drawPrice() {
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
                    style: TextStyle(fontSize: 16, color: CustomColors.grayOne),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    (double.tryParse(widget.data["total_price"]) -
                            widget.data["shipping_cost"])
                        .toString(),
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
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.of(context).getTranslated("shipping_cost"),
                    style: TextStyle(fontSize: 16, color: CustomColors.grayOne),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.data["shipping_cost"].toString(),
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
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.of(context).getTranslated("total"),
                    style: TextStyle(fontSize: 16, color: CustomColors.grayOne),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.data["total_price"].toString(),
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
  }
}
