import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:matager/controller/about_us_and_terms_of_use_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';

import 'homepage.dart';

class TermsOfUseScreen extends StatefulWidget {
  @override
  _TermsOfUseScreenState createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  AboutAndTermsOfUseAPI aboutUsAPI;

  @override
  void initState() {
    aboutUsAPI = AboutAndTermsOfUseAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: aboutUsAPI.getTermsOfUse(
                      AppLocale.of(context).getTranslated("lang") == "English"
                          ? "ar"
                          : "en"),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return emptyPage(context);
                        break;
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return loading(context, .75);
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          return Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (context, pos) {
                                Map map = snapshot.data['${pos + 1}'];
                                print(map);
                                return _drawFirstCardOfInfo(map, pos);
                              },
                            ),
                          );
                        } else
                          return emptyPage(context);
                        break;
                    }
                    return emptyPage(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawFirstCardOfInfo(Map map, int pos) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Html(
                      data: map["content"] == null ? "" : map["content"],
                      style: {
                        ".main-title": Style(
                            textDecorationStyle: TextDecorationStyle.double,
                            color: CustomColors.primary,
                            fontWeight: FontWeight.w600),
                        "p": Style(
                            textDecorationStyle: TextDecorationStyle.double,
                            fontWeight: FontWeight.w600),
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
