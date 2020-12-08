import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matager/controller/Authentication_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/utilities/theme.dart';

class UpdateProfileScreen extends StatefulWidget {
  Map data;
  String token;

  UpdateProfileScreen(this.data, this.token);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<ScaffoldState> _profileScaffoldKey =
      new GlobalKey<ScaffoldState>();

  Authentication authentication;
  TextEditingController _firstNameEditingText;
  TextEditingController _lastNameEditingText;
  TextEditingController _emailEditingText;
  File _image;
  final picker = ImagePicker();

  TextEditingController _phoneEditingText;
  TextEditingController _oldPassWordText;
  TextEditingController _newPassWordText;
  String dropdownText;
  final _contactUsKey = GlobalKey<FormState>();

  @override
  void initState() {
    authentication = Authentication();
    _firstNameEditingText = TextEditingController();
    _lastNameEditingText = TextEditingController();
    _emailEditingText = TextEditingController();
    _phoneEditingText = TextEditingController();
    _oldPassWordText = TextEditingController();
    _newPassWordText = TextEditingController();
    _firstNameEditingText.text = widget.data["name"];
    _lastNameEditingText.text = widget.data["lastname"];
    _emailEditingText.text = widget.data["email"];
    _phoneEditingText.text = widget.data["phone"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _profileScaffoldKey,
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  AppLocale.of(context).getTranslated("drawer_update"),
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
                          width: 125,
                          height: 125,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 0.5, color: CustomColors.whiteBG),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                width: 125,
                                height: 125,
                                child: ClipOval(
                                  child: (widget.data["image"] == null ||
                                          widget.data["image"] == '')
                                      ? Image.asset(
                                          'assets/images/image_2.jpg',
                                        )
                                      : Image(
                                          loadingBuilder: (context, image,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null) {
                                              return image;
                                            }
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          image: NetworkImage(
                                              widget.data["image"],
                                              scale: 1.0),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.45,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 0.5,
                                        color: CustomColors.whiteBG),
                                    gradient: LinearGradient(colors: [
                                      CustomColors.gray,
                                      CustomColors.gray
                                    ]),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Center(
                                      child: Icon(
                                Icons.add,
                                color: CustomColors.whiteBG,
                                size: 36,
                              ))),
                            ],
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: getImage,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 125,
                            height: 125,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 0.5, color: CustomColors.whiteBG),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: 125,
                                  height: 125,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 0.5,
                                        color: CustomColors.whiteBG),
                                  ),
                                  child: ClipOval(
                                      child: Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  )),
                                ),
                                Opacity(
                                  opacity: 0.45,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 0.5,
                                          color: CustomColors.whiteBG),
                                      gradient: LinearGradient(colors: [
                                        CustomColors.gray,
                                        CustomColors.gray
                                      ]),
                                    ),
                                  ),
                                ),
                                Container(
                                    child: Center(
                                        child: Icon(
                                  Icons.add,
                                  color: CustomColors.whiteBG,
                                  size: 36,
                                ))),
                              ],
                            )),
                      ),
                    ),
              _drawForm(widget.data)
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

  Widget _drawForm(
    Map map,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Form(
        key: _contactUsKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .015),
                _drawFirstName(18),
                SizedBox(height: MediaQuery.of(context).size.height * .015),
                _drawLastName(18),
                SizedBox(height: MediaQuery.of(context).size.height * .015),
                _drawEmail(18),
                SizedBox(height: MediaQuery.of(context).size.height * .015),
                _drawPhone(18),
                SizedBox(height: MediaQuery.of(context).size.height * .015),
                _drawOldPass(18),
                SizedBox(height: MediaQuery.of(context).size.height * .015),
                _drawNewPass(18),
                SizedBox(height: MediaQuery.of(context).size.height * .015),
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
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: _firstNameEditingText,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: widget.data["name"] == null
              ? (AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "اسمك"
                  : 'Your name')
              : widget.data["name"],
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

  Widget _drawLastName(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: _lastNameEditingText,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: widget.data["lastname"] == null
              ? (AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "اسم العائلة"
                  : 'Your family name')
              : widget.data["name"],
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

  Widget _drawEmail(double textSize) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        controller: _emailEditingText,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: widget.data["email"],
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
        validator: (onValue) {
          if (!onValue.isEmpty) {
            if (!(regex.hasMatch(onValue))) {
              return "Invalid Email";
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
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: _phoneEditingText,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: widget.data["phone"] == null
              ? (AppLocale.of(context).getTranslated("lang") == 'English'
                  ? "رقم هاتفك"
                  : 'Your phone')
              : widget.data["phone"],
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

  Widget _drawOldPass(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: _oldPassWordText,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: AppLocale.of(context).getTranslated("old_pass"),
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

  Widget _drawNewPass(double textSize) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: _newPassWordText,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: AppLocale.of(context).getTranslated("new_pass"),
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
        if (_contactUsKey.currentState.validate()) {
          authentication
              .updateUser(
            widget.data['id'],
            _firstNameEditingText.text,
            _lastNameEditingText.text,
            _emailEditingText.text,
            _phoneEditingText.text,
            _oldPassWordText.text,
            _newPassWordText.text,
            widget.token,
            _image,
          )
              .then((value) {
            if (value == "true") {
              final snackBar = SnackBar(
                backgroundColor: CustomColors.greenLightBG,
                content: Text(
                  AppLocale.of(context).getTranslated("lang") == 'English'
                      ? "تم تحديث معلوماتك"
                      : 'Your information has been updated',
                  style: TextStyle(color: CustomColors.greenLightFont),
                ),
              );

              _profileScaffoldKey.currentState.showSnackBar(snackBar);
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
