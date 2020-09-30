import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/product/display_super_market_prodect.dart';

class TabScreenoFCategory extends StatefulWidget {
  List map;
  int marketId;

  TabScreenoFCategory(this.map, this.marketId);

  @override
  _TabScreenoFCategoryState createState() => _TabScreenoFCategoryState();
}

class _TabScreenoFCategoryState extends State<TabScreenoFCategory> {
  @override
  Widget build(BuildContext context) {
    return _drawCategoryProduct(widget.map);
  }

  Widget _drawCategoryProduct(List map) {
    return map.length >= 1
        ? Container(
            padding: EdgeInsets.only(top: 8),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _drawListOfCategoryProduct(map),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                children: [
                  Container(
                    child: Image.asset(
                      "assets/images/box.jpg",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                  Text(
                    AppLocale.of(context).getTranslated("category_dis"),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ));
  }

  Widget _drawListOfCategoryProduct(List map) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(map.length, (index) {
        return _drawCardOfProducts(
          map[index],
        );
      }),
      childAspectRatio: .7,
    );
  }

//
  Widget _drawCardOfProducts(Map data) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        width: MediaQuery.of(context).size.width * 0.45,
        height: MediaQuery.of(context).size.height * 0.15,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DisplayMarketProduct(
                widget.marketId,
                data["id"],
                AppLocale.of(context).getTranslated("lang") == 'English'
                    ? data["name"]
                    : data["name_en"],
              ),
            ));
          },
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: (data["image"] == null)
                    ? Image.asset(
                        "assets/images/boxImage.png",
                      )
                    : Image(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        loadingBuilder:
                            (context, image, ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) {
                            return image;
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        image: NetworkImage(data["image"], scale: 1.0),
                        fit: BoxFit.cover,
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: Center(
                              child: Text(
                            AppLocale.of(context).getTranslated("lang") ==
                                    'English'
                                ? data["name"]
                                : data["name_en"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
