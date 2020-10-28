import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/theme.dart';

import 'get_location.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  child: Column(
                children: [
                  _drawLogo(),
                ],
              )),
              _drawLoginButton(18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawLogo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.38,
      child: Image.asset(
        "assets/images/matager.png",
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _drawTextGetLocation() {
    return Text(
      AppLocale.of(context).getTranslated("your_loc"),
      maxLines: 3,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

//   map["id"],
  //   AppLocale.of(context).getTranslated("lang") == 'English'
  //       ? map["name"]
  //       : map["name_en"],
  Widget _drawLoginButton(double textButtonSize) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CheckLocation(0),
          ),
        );
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
            AppLocale.of(context).getTranslated("start"),
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
}
