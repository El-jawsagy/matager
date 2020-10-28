import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

class StoreCommentsScreen extends StatefulWidget {
  String name;
  int storeId;

  StoreCommentsScreen(this.name, this.storeId);

  @override
  _StoreCCommentsScreejState createState() => _StoreCCommentsScreejState();
}

class _StoreCCommentsScreejState extends State<StoreCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteBG,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textWidthBasis: TextWidthBasis.parent,
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: CustomColors.whiteBG,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart,
              color: CustomColors.whiteBG,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  Text(
                    AppLocale.of(context).getTranslated("comments"),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.primary),
                    textWidthBasis: TextWidthBasis.parent,
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return emptyPage(context);
                break;
              case ConnectionState.waiting:
              case ConnectionState.active:
                return loading(context, 1);
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, pos) {
                        Map map = snapshot.data[pos];
                        return snapshot.data.length >= 1
                            ? _drawCardOfComment(
                                map,
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Image.asset(
                                          "assets/images/box.jpg",
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                        ),
                                      ),
                                      Text(
                                        AppLocale.of(context)
                                            .getTranslated("comments_dis"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ));
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
    );
  }

  Widget _drawCardOfComment(Map data) {
    return Container();
  }
}
