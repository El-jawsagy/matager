import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:matager/controller/store/comment_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

class StoreCommentsScreen extends StatefulWidget {
  String name;
  int storeId;

  StoreCommentsScreen(this.name, this.storeId);

  @override
  _StoreCommentsScreenState createState() => _StoreCommentsScreenState();
}

class _StoreCommentsScreenState extends State<StoreCommentsScreen> {
  CommentMethodAPI commentMethodAPI;

  @override
  void initState() {
    commentMethodAPI = CommentMethodAPI();

    super.initState();
  }

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                future: commentMethodAPI.getFavoriteItems(widget.storeId),
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
                        if (snapshot.data.length > 0) {
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Image.asset(
                                                  "assets/images/box.jpg",
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.25,
                                                ),
                                              ),
                                              Text(
                                                AppLocale.of(context)
                                                    .getTranslated(
                                                        "comments_dis"),
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
                        } else {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      "assets/images/box.jpg",
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
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
                            ),
                          );
                        }
                      } else
                        return emptyPage(context);
                      break;
                  }
                  return emptyPage(context);
                }),
          ],
        ),
      ),
    );
  }

  Widget _drawCardOfComment(Map data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Stack(
        children: <Widget>[
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          child: (data["userimg"] == null)
                              ? Image.asset(
                                  "assets/images/avatar.jpg",
                                )
                              : Image(
                                  height:
                                      MediaQuery.of(context).size.height * .09,
                                  loadingBuilder: (context, image,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) {
                                      return image;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  image:
                                      NetworkImage(data["userimg"], scale: 1.0),
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              data["username"] == null ? "" : data["username"],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: CustomColors.primary,
                              ),
                              maxLines: 1,
                              textAlign:
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "English"
                                      ? TextAlign.right
                                      : TextAlign.left,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              data["created_at"] == null
                                  ? ""
                                  : data["created_at"],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: CustomColors.gray,
                              ),
                              maxLines: 1,
                              textAlign:
                                  AppLocale.of(context).getTranslated("lang") ==
                                          "English"
                                      ? TextAlign.right
                                      : TextAlign.left,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    data["comment"] == null ? "" : data["comment"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RatingBar.builder(
                        ignoreGestures: true,
                        initialRating: data["rate"].floorToDouble(),
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: CustomColors.ratingBG,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    color: CustomColors.gray,
                    height: 5,
                  ),
                ),
                data["replies"].length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                widget.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: CustomColors.primary,
                                ),
                                maxLines: 1,
                                textAlign: AppLocale.of(context)
                                            .getTranslated("lang") ==
                                        "English"
                                    ? TextAlign.left
                                    : TextAlign.right,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                data["replies"].length > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                data["replies"][0]["created_at"] == null
                                    ? ""
                                    : data["replies"][0]["created_at"],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: CustomColors.gray,
                                ),
                                maxLines: 1,
                                textAlign: AppLocale.of(context)
                                            .getTranslated("lang") ==
                                        "English"
                                    ? TextAlign.left
                                    : TextAlign.right,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                data["replies"].length > 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            data["replies"][0]["comment"] == null
                                ? ""
                                : data["replies"][0]["comment"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
