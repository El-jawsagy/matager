import 'package:flutter/material.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/supermarket/product/display_super_market_prodect.dart';
import 'package:matager/view/utilities/theme.dart';

import 'display_pharmace_medications.dart';

class TabScreenoFCategory extends StatefulWidget {
  List map;
  String status;
  int marketId;
  String marketName;
  String token;
  double latitude, longitude;
  double nameSize;

  TabScreenoFCategory(
    this.map,
    this.status,
    this.marketId,
    this.marketName,
    this.token,
    this.latitude,
    this.longitude,
    this.nameSize,
  );

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
            child: _drawListOfCategoryProduct(map, widget.nameSize),
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

//display list of products
  Widget _drawListOfCategoryProduct(
    List map,
    nameSize,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(map.length, (index) {
        return _drawCardOfProducts(
          nameSize,
          map[index],
        );
      }),
      childAspectRatio: .75,
    );
  }

// display each product
  Widget _drawCardOfProducts(
    nameSize,
    Map data,
  ) {
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
            if (data['name'] == "ادويه" || data["name_en"] == "Medicines") {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PharmacyPrescriptionScreen(widget.token,
                      widget.status, widget.marketId, widget.marketName),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayMarketProduct(
                    widget.marketId,
                    data["id"],
                    widget.status,
                    AppLocale.of(context).getTranslated("lang") == 'English'
                        ? data["name"]
                        : data["name_en"],
                    widget.marketName,
                    widget.token,
                    widget.latitude,
                    widget.longitude,
                    0,
                  ),
                ),
              );
            }
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
                  Container(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    decoration: BoxDecoration(
                        color: CustomColors.primary,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7))),
                    child: Center(
                        child: Text(
                      AppLocale.of(context).getTranslated("lang") == 'English'
                          ? data["name"]
                          : data["name_en"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: nameSize,
                          color: CustomColors.whiteBG),
                      textAlign: TextAlign.center,
                    )),
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
