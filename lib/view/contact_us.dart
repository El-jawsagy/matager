import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matager/controller/about_us_and_terms_of_use_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/theme.dart';

import 'homepage.dart';

class ContactUsScreen extends StatefulWidget {
  List data;
  String lang;

  ContactUsScreen(this.data, this.lang);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
   final GlobalKey<ScaffoldState> _contactUsScaffoldKey = new GlobalKey<
      ScaffoldState>();

  AboutAndTermsOfUseAPI contactUsAPI;
  TextEditingController _firstNameEditingText;
  TextEditingController _emailEditingText;

  TextEditingController _phoneEditingText;
  TextEditingController _massageEditingText;
  String dropdownText;
  ValueNotifier<String> category;
  final _contactUsKey = GlobalKey<FormState>();

  @override
  void initState() {
    contactUsAPI = AboutAndTermsOfUseAPI();
    if (widget.lang == "English") {
      category = ValueNotifier(
        "اختر نوع المتجر",
      );
    } else {
      category = ValueNotifier(
        "Choose store type",
      );
    }

    _firstNameEditingText = TextEditingController();
    _emailEditingText = TextEditingController();
    _phoneEditingText = TextEditingController();
    _massageEditingText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> strings = [];
    if (AppLocale.of(context).getTranslated("lang") == "English") {
      strings.add("اختر نوع المتجر");
    } else {
      strings.add("Choose store type");
    }
    for (var i in widget.data) {
      if (AppLocale.of(context).getTranslated("lang") == "English") {
        strings.add(i["name"]);
      } else {
        strings.add(i["name_en"]);
      }
    }
    if (AppLocale.of(context).getTranslated("lang") == "English") {
      strings.add("مستخدم");
    } else {
      strings.add("User");
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _contactUsScaffoldKey,
        backgroundColor: CustomColors.grayThree,
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(AppLocale.of(context).getTranslated("image")),
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
            children: [_drawForm(strings)],
          ),
        ),
      ),
    );
  }

  Widget _drawForm(List<String> map,) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Form(
        key: _contactUsKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  AppLocale.of(context).getTranslated("lang") == "English"
                      ? "تواصل معنا"
                      : "CONTACT US ",
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
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.2,
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.1,
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
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .015),
                _drawFirstName(18),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .015),
                _drawEmail(18),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .015),
                _drawPhone(18),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .015),
                _drawChooseCountry(
                  map,
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .015),
                _drawMassage(18),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * .015),
                _drawContactUsButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawFirstName(double textSize) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      child: TextFormField(
        controller: _firstNameEditingText,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("first_name"),
          labelStyle: TextStyle(
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
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
          }
          return null;
        },
        onChanged: (vaue) {},
      ),
    );
  }

  Widget _drawEmail(double textSize) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      child: TextFormField(
        controller: _emailEditingText,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("email"),
          labelStyle: TextStyle(
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
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
          } else {
            if (!(regex.hasMatch(onValue))) {
              return AppLocale.of(context).getTranslated("lang") ==
                  'English'
                  ? "بريد إلكتروني خاطئ"
                  : "Invalid Email";
            }
          }
          return null;
        },
        onChanged: (vaue) {},
      ),
    );
  }

  Widget _drawPhone(double textSize) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      child: TextFormField(
        controller: _phoneEditingText,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("phone"),
          labelStyle: TextStyle(
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
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
          }
          return null;
        },
        onChanged: (vaue) {},
      ),
    );
  }

  Widget _drawChooseCountry(List<String> list) {
    return ValueListenableBuilder(
      valueListenable: category,
      builder: (BuildContext context, value, Widget child) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: CustomColors.grayBorder,
              ),
              borderRadius: BorderRadius.circular(3)),
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          height: MediaQuery
              .of(context)
              .size
              .height * .08,
          child: Center(
            child: DropdownButton<String>(
              value: category.value,
              icon: Icon(Icons.arrow_drop_down_outlined),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: CustomColors.grayText),
              underline: Container(
                color: CustomColors.whiteBG,
              ),
              onChanged: (String newValue) {
                category.value = newValue;
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _drawMassage(double textSize) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      child: TextFormField(
        controller: _massageEditingText,
        maxLines: 10,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("massage"),
          labelStyle: TextStyle(
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
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
          }
          return null;
        },
        onChanged: (vaue) {},
      ),
    );
  }

  Widget _drawContactUsButton() {
    return InkWell(
      onTap: () async {
        if (_contactUsKey.currentState.validate()) {
          contactUsAPI
              .sendContactUs(
            _firstNameEditingText.text,
            _phoneEditingText.text,
            _massageEditingText.text,
            category.value,
            _emailEditingText.text,
          )
              .then((value) {
            if (value == "true") {
              final snackBar = SnackBar(
                  backgroundColor: CustomColors.greenLightBG,
                  content: Text(
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? "مرحباُ : تم ارسال رسالتك ب نجاح.."
                        : 'Hello: Your message was sent with success..',
                    style: TextStyle(color: CustomColors.greenLightFont),
                  ));
              _contactUsScaffoldKey.currentState.showSnackBar(snackBar);
            }
          });
        }
      },
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * .65,
        height: MediaQuery
            .of(context)
            .size
            .height * .07,
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
