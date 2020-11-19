import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matager/controller/orders_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/utilities/theme.dart';

class PharmacyPrescriptionScreen extends StatefulWidget {
  String token;
  String status;

  int storeId;

  PharmacyPrescriptionScreen(this.token, this.status, this.storeId);

  @override
  _PharmacyPrescriptionScreenState createState() =>
      _PharmacyPrescriptionScreenState();
}

class _PharmacyPrescriptionScreenState
    extends State<PharmacyPrescriptionScreen> {
  static final GlobalKey<ScaffoldState> _pharmacyScaffoldKey =
      new GlobalKey<ScaffoldState>();
  OrdersApi ordersApi;

  File _image;
  final picker = ImagePicker();

  TextEditingController _massageText;
  String dropdownText;

  @override
  void initState() {
    ordersApi = OrdersApi();
    _massageText = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _pharmacyScaffoldKey,
        backgroundColor: CustomColors.grayThree,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocale.of(context).getTranslated("app_name"),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textWidthBasis: TextWidthBasis.parent,
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  AppLocale.of(context).getTranslated("lang") == "English"
                      ? " ادخل الادوية المطلوبة"
                      : "  Enter the required medications",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: CustomColors.primary,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Stack(
                  children: [
                    Divider(
                      color: CustomColors.red,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Divider(
                            color: CustomColors.primary,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _drawForm(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  AppLocale.of(context).getTranslated("lang") == "English"
                      ? "ارفق روشتة الدكتور"
                      : "Attach the doctor's prescription",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: CustomColors.primary,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: Stack(
                  children: [
                    Divider(
                      color: CustomColors.red,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          child: Divider(
                            color: CustomColors.primary,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _image == null
                  ? InkWell(
                      onTap: getImage,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                width: 0.5, color: CustomColors.whiteBG),
                          ),
                          child: ClipRect(
                              child: Image.asset(
                            'assets/images/Prescription.jpg',
                          )),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: getImage,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                width: 0.5, color: CustomColors.whiteBG),
                          ),
                          child: ClipRect(
                              child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                    ),
              widget.status == "غير متاح"
                  ? _drawStoreClose()
                  : _drawContactUsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _drawForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              _drawMassage(18),
              SizedBox(height: MediaQuery.of(context).size.height * .015),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawMassage(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: _massageText,
        maxLines: 10,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: AppLocale.of(context).getTranslated("lang") == "English"
              ? "من فضلك ادخل الادوية المطلوبة كل دواء فى سطر منفصل "
              : "Please enter the required medicines for each medicine on a separate line",
          hintStyle: TextStyle(
            fontSize: textSize,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.grayBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.grayBorder,
            ),
          ),
        ),
        onChanged: (vaue) {},
      ),
    );
  }

  Widget _drawContactUsButton() {
    return InkWell(
      onTap: () async {
        if (_massageText.text.isNotEmpty || _image != null) {
          ordersApi
              .makePharmaceOrder(
            widget.storeId,
            _massageText.text,
            _image,
          )
              .then((value) {
            print(value);
            if (value == "true") {
              final snackBar = SnackBar(
                  backgroundColor: CustomColors.greenLightBG,
                  content: Text(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? "مرحباُ : سيتم مراجعه الادويه المطلوبه وفي حاله اتاحتها ستجدها في سله المشتريات الخاصه بك..."
                        : 'Hello: The required medicines will be reviewed, and if available, you will find them in your shopping cart ...',
                    style: TextStyle(color: CustomColors.greenLightFont),
                  ));

              _pharmacyScaffoldKey.currentState.showSnackBar(snackBar);
            } else {
              final snackBar = SnackBar(
                backgroundColor: CustomColors.ratingLightBG,
                content: Text(
                  AppLocale.of(context).getTranslated("lang") == 'English'
                      ? "لم يرسل طلبك بعد برجاء التاكد من الاتصال بالانترنت و المحاولة مرة اخري"
                      : 'Your request has not been sent yet. Please check your internet connection and try again',
                  style: TextStyle(color: CustomColors.ratingLightFont),
                ),
              );

              _pharmacyScaffoldKey.currentState.showSnackBar(snackBar);
            }
          });
        } else {
          final snackBar = SnackBar(
              backgroundColor: CustomColors.ratingLightBG,
              content: Text(
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? "برجاء كتابة الادوية المطلوبة او رفع روشتة الدكتور."
                    : "Please write the required medications or raise the doctor's prescription.",
                style: TextStyle(color: CustomColors.ratingLightFont),
              ));

          _pharmacyScaffoldKey.currentState.showSnackBar(snackBar);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .65,
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
            AppLocale.of(context).getTranslated("send"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: CustomColors.whiteBG,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawStoreClose() {
    return InkWell(
      onTap: () async {
        final snackBar = SnackBar(
            backgroundColor: CustomColors.ratingLightBG,
            content: Text(
              AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "مرحباُ : ناسف هذا المتجر مغلق الان.."
                  : 'Hello: Sorry, this store is now closed ..',
              style: TextStyle(color: CustomColors.ratingLightFont),
            ));

        _pharmacyScaffoldKey.currentState.showSnackBar(snackBar);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .65,
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
            AppLocale.of(context).getTranslated("send"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: CustomColors.whiteBG,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
