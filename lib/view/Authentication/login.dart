import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:matager/controller/Authentication_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/Authentication/signup_screen.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/controller/cart/cart_items_bloc_and_Api.dart';

import '../homepage.dart';

class LoginScreen extends StatefulWidget {
  double latitude, longitude;

  LoginScreen(this.latitude, this.longitude);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Authentication authentication = Authentication();
  CardMethodApi cardMethodApi = CardMethodApi();

  TextEditingController _emailTextController;

  TextEditingController _passwordTextController;

  IconData _icon = Icons.visibility_off;

  bool _isVisible = true;

  bool _isHash = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordTextController = TextEditingController();
    _emailTextController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    LoginScreenProperties loginScreenProperties =
        LoginScreenProperties(detectedScreen);
    //WillPopScope make you can control with back button in android
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ExactAssetImage("assets/images/banner_two.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              _drawLogo(),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .04),
                              _drawEditText(
                                Icons.email,
                                AppLocale.of(context).getTranslated("email"),
                                AppLocale.of(context).getTranslated("wrong"),
                                loginScreenProperties.editTextSize,
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .04),
                              _drawPasswordEditText(
                                loginScreenProperties.editTextSize,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .005),
                              _drawForgetPass(
                                  loginScreenProperties.forgetTextSize),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .08),
                              _drawLoginButton(
                                  loginScreenProperties.loginTextSize),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .1,
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: _drawSignUp(
                                      loginScreenProperties.signUpText),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawLogo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.28,
      child: Image.asset(
        "assets/images/boxImage.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _drawEditText(IconData icon, String boxName, String validatorText,
      double titleTextSize) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        style: TextStyle(fontSize: titleTextSize),
        textAlign: TextAlign.left,
        keyboardType: TextInputType.emailAddress,
        controller: _emailTextController,
        decoration: InputDecoration(
          labelText: boxName,
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          suffixIcon: Icon(
            icon,
            color: CustomColors.dark,
          ),
        ),
        validator: (onValue) {
          if (onValue.isEmpty) {
            return validatorText;
          } else {
            if (!(regex.hasMatch(onValue))) {
              return "Invalid Email";
            }
          }
          return null;
        },
      ),
    );
  }

  Widget _drawPasswordEditText(double textFontSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        style: TextStyle(
          fontSize: textFontSize,
        ),
        obscureText: _isHash,
        controller: _passwordTextController,
        decoration: InputDecoration(
          hintText: AppLocale.of(context).getTranslated("pass"),
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
          suffixIcon: IconButton(
            onPressed: () {
              if (_isVisible) {
                setState(() {
                  _icon = Icons.visibility;
                  _isHash = false;
                  _isVisible = false;
                  this._emailTextController.text = _emailTextController.text;
                  this._passwordTextController.text =
                      _passwordTextController.text;
                });
              } else if (!_isVisible) {
                setState(() {
                  _icon = Icons.visibility_off;
                  _isHash = true;
                  _isVisible = true;
                  this._emailTextController.text = _emailTextController.text;
                  this._passwordTextController.text =
                      _passwordTextController.text;
                });
              }
            },
            icon: Icon(
              _icon,
              color: CustomColors.dark,
            ),
          ),
        ),
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
          }
          return null;
        },
      ),
    );
  }

  Widget _drawForgetPass(double forgetTextSize) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (context) => ForgetPassword(widget.lang)));
            },
            child: Text(
              AppLocale.of(context).getTranslated("forget"),
              style: TextStyle(
                fontSize: forgetTextSize,
                color: CustomColors.dark,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawLoginButton(double textButtonSize) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          authentication
              .login(_emailTextController.text, _passwordTextController.text)
              .then((value) async {
            print("this is value of login $value");
            switch (value) {
              case "email wrong":
                showDialogWidget("make sure of email ", context);
                break;

              case "password wrong":
                showDialogWidget("make sure of password ", context);
                break;

              default:
                if (value.length > 100) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  if (prefs.get("cart") != null) {
                    cardMethodApi.cartUpLoadBeforLogin(
                      prefs.get("cart"),
                      value,
                      prefs.get("UserId"),
                    );
                  }
                } else
                  showDialogWidget("we have an error", context);
                break;
            }
          });
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
            AppLocale.of(context).getTranslated("log"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textButtonSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawSignUp(
    double signUpScreen,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          AppLocale.of(context).getTranslated("sign_que"),
          style: TextStyle(
            fontSize: 20,
            color: CustomColors.primary,
            fontWeight: FontWeight.w200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SignUpScreen(widget.latitude, widget.longitude)));
            },
            child: Text(
              AppLocale.of(context).getTranslated("sign"),
              style: TextStyle(
                fontSize: 20,
                color: CustomColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
// ignore: must_call_super
  void dispose() {
    _passwordTextController.dispose();
    _emailTextController.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
//  Future<void> ValidateForm() {
//    String name, pass;
//    name = _emailTextController.text;
//    pass = _passwordTextController.text;
//
//    if (_formKey.currentState.validate()) {
//      auth.logIn(context, name, pass).then((onVal) {
//        if (onVal.length <= 50) {
//          showDialogWidget("make sure of email or password", context);
//        } else {
//          Navigator.of(context).pushReplacementNamed("/home");
//        }
//      });
//    }
//  }
}
