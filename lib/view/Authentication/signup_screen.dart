import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/controller/Authentication_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';

import '../homepage.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  double latitude, longitude;

  SignUpScreen(this.latitude, this.longitude);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpKey = GlobalKey<FormState>();

  Authentication authentication = Authentication();

  IconData _icon = Icons.visibility_off;

  bool _isVisible = true;

  bool _isHash = true;

  IconData _iconConf = Icons.visibility_off;

  bool _isVisibleConf = true;

  bool _isHashConf = true;

  TextEditingController _firstNameEditingText;

  TextEditingController _passwordEditingText;

  TextEditingController _conformPassEditingText;

  TextEditingController _phoneEditingText;

  TextEditingController _emailEditingText;
  TextEditingController _lastNameEditingText;

  @override
  void initState() {
    _firstNameEditingText = TextEditingController();
    _lastNameEditingText = TextEditingController();
    _emailEditingText = TextEditingController();
    _phoneEditingText = TextEditingController();
    _passwordEditingText = TextEditingController();
    _conformPassEditingText = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    SignUpScreenProperties signUpProperties =
        SignUpScreenProperties(detectedScreen);
    return Stack(
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Form(
                      key: _signUpKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          _drawLogo(),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .012),
                          _drawFirstName(signUpProperties.editTextSize),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .012),
                          _drawLastName(signUpProperties.editTextSize),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .012),
                          _drawPhone(signUpProperties.editTextSize),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .012),
                          _drawEmail(signUpProperties.editTextSize),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .012),
                          _drawPasswordEditText(signUpProperties.editTextSize),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * .012),
                          _drawConfPasswordEditText(
                              signUpProperties.editTextSize),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .08),
                          _drawSignUpButton(signUpProperties.signUPTextSize),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * .01),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: _drawLogin(signUpProperties.signUpText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _drawLogo() {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.05,
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Image.asset(
        "assets/images/boxImage.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _drawFirstName(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: _firstNameEditingText,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("first_name"),
          labelStyle: TextStyle(
            fontSize: textSize,
          ),
          suffixIcon: Icon(
            Icons.person,
            color: CustomColors.dark,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
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

  Widget _drawLastName(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: _lastNameEditingText,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("last_name"),
          labelStyle: TextStyle(
            fontSize: textSize,
          ),
          suffixIcon: Icon(
            Icons.person,
            color: CustomColors.dark,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
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

  Widget _drawPhone(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: _phoneEditingText,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("phone"),
          labelStyle: TextStyle(
            fontSize: textSize,
          ),
          suffixIcon: Icon(
            Icons.phone,
            color: CustomColors.dark,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
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

  Widget _drawEmail(double textSize) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: _emailEditingText,
        decoration: InputDecoration(
          labelText: AppLocale.of(context).getTranslated("email"),
          labelStyle: TextStyle(
            fontSize: textSize,
          ),
          suffixIcon: Icon(
            Icons.email,
            color: CustomColors.dark,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
        ),
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
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

  Widget _drawPasswordEditText(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        obscureText: _isHash,
        controller: _passwordEditingText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              if (_isVisible) {
                setState(() {
                  _icon = Icons.visibility;
                  _isHash = false;
                  _isVisible = false;
                  this._phoneEditingText.text = _phoneEditingText.text;
                  this._firstNameEditingText.text = _firstNameEditingText.text;
                  this._conformPassEditingText.text =
                      _conformPassEditingText.text;
                  this._passwordEditingText.text = _passwordEditingText.text;
                });
              } else if (!_isVisible) {
                setState(() {
                  _icon = Icons.visibility_off;
                  _isHash = true;
                  _isVisible = true;
                  this._phoneEditingText.text = _phoneEditingText.text;
                  this._firstNameEditingText.text = _firstNameEditingText.text;
                  this._conformPassEditingText.text =
                      _conformPassEditingText.text;
                  this._passwordEditingText.text = _passwordEditingText.text;
                });
              }
            },
            icon: Icon(
              _icon,
              color: CustomColors.dark,
            ),
          ),
          labelText: AppLocale.of(context).getTranslated("pass"),
          labelStyle: TextStyle(
            fontSize: textSize,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
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

  Widget _drawConfPasswordEditText(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        obscureText: _isHashConf,
        controller: _conformPassEditingText,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              if (_isVisibleConf) {
                setState(() {
                  _iconConf = Icons.visibility;
                  _isHashConf = false;
                  _isVisibleConf = false;
                  this._phoneEditingText.text = _phoneEditingText.text;
                  this._firstNameEditingText.text = _firstNameEditingText.text;
                  this._conformPassEditingText.text =
                      _conformPassEditingText.text;
                  this._passwordEditingText.text = _passwordEditingText.text;
                });
              } else if (!_isVisibleConf) {
                setState(() {
                  _iconConf = Icons.visibility_off;
                  _isHashConf = true;
                  _isVisibleConf = true;
                  this._phoneEditingText.text = _phoneEditingText.text;
                  this._firstNameEditingText.text = _firstNameEditingText.text;
                  this._conformPassEditingText.text =
                      _conformPassEditingText.text;
                  this._passwordEditingText.text = _passwordEditingText.text;
                });
              }
            },
            icon: Icon(
              _iconConf,
              color: CustomColors.dark,
            ),
          ),
          labelText: AppLocale.of(context).getTranslated("con_pass"),
          labelStyle: TextStyle(
            fontSize: textSize,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.dark,
            ),
          ),
        ),
        validator: (onValue) {
          if (onValue.isEmpty) {
            return AppLocale.of(context).getTranslated("wrong");
          } else if (onValue.isNotEmpty) {
            if (onValue == _passwordEditingText.text) {
              return null;
            }
            return "Password does not match";
          }
          return null;
        },
      ),
    );
  }

  Widget _drawSignUpButton(double textSize) {
    return InkWell(
      onTap: () async {
        if (_signUpKey.currentState.validate()) {
          authentication
              .signUp(
                  _firstNameEditingText.text,
                  _lastNameEditingText.text,
                  _phoneEditingText.text,
                  _emailEditingText.text,
                  _emailEditingText.text)
              .then((value) {
            switch (value) {
              case "email exist":
                showDialogWidget("email is already exist ", context);
                break;
              case "phone exist":
                showDialogWidget("phone is already exist ", context);
                break;
              case "password wrong":
                showDialogWidget("make sure of password ", context);
                break;

              default:
                print(value);
                if (value.length > 100) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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
            AppLocale.of(context).getTranslated("sign"),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textSize,
              color: CustomColors.whiteBG,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawLogin(double loginScreen) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  LoginScreen(widget.latitude, widget.longitude)),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocale.of(context).getTranslated("log_que"),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w200,
              color: CustomColors.primary,
            ),
          ),
          Text(
            AppLocale.of(context).getTranslated("log"),
            style: TextStyle(
                fontSize: 20,
                color: CustomColors.dark,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordEditingText.dispose();

    _conformPassEditingText.dispose();

    _firstNameEditingText.dispose();

    _phoneEditingText.dispose();

    _icon = Icons.visibility_off;

    _isVisible = true;

    _isHash = true;

    _iconConf = Icons.visibility_off;

    _isVisibleConf = true;

    _isHashConf = true;

    super.dispose();
  }
}
