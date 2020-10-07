import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/prefrences.dart';
import 'package:matager/view/utilities/theme.dart';

class FavoriteScreen extends StatefulWidget {
  double latitude, longitude;
  FavoriteScreen(this.latitude, this.longitude);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();

}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("drawer_fav"),
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
      drawer: NavDrawer(widget.latitude,widget.longitude),
      body: FutureBuilder(
        future: Preference.getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                child: Text(
                  AppLocale.of(context).getTranslated("drawer_fav"),
                ),
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    AppLocale.of(context).getTranslated("apology"),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen(widget.latitude,widget.longitude)));
                          },
                          child: Text(
                            AppLocale.of(context).getTranslated("log"),
                            style: TextStyle(
                              color: CustomColors.whiteBG,
                            ),
                          ),
                          color: CustomColors.primary,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
