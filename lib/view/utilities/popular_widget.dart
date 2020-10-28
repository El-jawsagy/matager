import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/theme.dart';

showDialogWidget(String str, BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        //title: new Text("Alert Dialog title"),
        content: new Text(str),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Ok"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

showWaiting(BuildContext contxt) {
  // flutter defined function
  showDialog(
    context: contxt,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        backgroundColor: Colors.transparent,
        title: new Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}

Widget emptyPage(
  BuildContext context,
) {
  return Container(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            "Page is Empty",
            style: TextStyle(
                color: CustomColors.whiteBG,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

bool switchLang(bool lang) {
  switch (lang) {
    case true:
      return false;
      break;
    case false:
      return true;
      break;
  }
  return true;
}

Widget loading(BuildContext context, double size) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * size,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocale.of(context).getTranslated("wait"),
              maxLines: 3,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            CircularProgressIndicator(
              backgroundColor: CustomColors.primary,
            ),
          ],
        ),
      ));
}

Widget noData(BuildContext context, double width, double height) {
  return Container(
    width: MediaQuery.of(context).size.width * width,
    height: MediaQuery.of(context).size.height * height,
    child: Center(
      child: Text("NO DATA"),
    ),
  );
}

Widget error(BuildContext context, Error error, double width, double height) {
  return Container(
    width: MediaQuery.of(context).size.width * width,
    height: MediaQuery.of(context).size.height * height,
    child: Center(
      child: Text("we found Error -> $error"),
    ),
  );
}

Widget noConnection(BuildContext context, double width, double height) {
  return Container(
    width: MediaQuery.of(context).size.width * width,
    height: MediaQuery.of(context).size.height * height,
    child: Center(
      child: Text(
        "No Connection with INTERNET",
      ),
    ),
  );
}

Widget drawDots({ValueNotifier pos, int length}) {
  return ValueListenableBuilder(
    valueListenable: pos,
    builder: (context, value, _) {
      return DotsIndicator(
          dotsCount: length,
          position: value.ceilToDouble(),
          decorator: DotsDecorator(
            color: CustomColors.gray,
            activeColor: CustomColors.primary,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ));
    },
  );
}
