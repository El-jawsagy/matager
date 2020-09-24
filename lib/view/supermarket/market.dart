import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:matager/controller/home_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'package:matager/view/utilities/theme.dart';

import 'display_super_market.dart';

class CheckLocation extends StatefulWidget {
  int id;
  String name;

  CheckLocation(this.id, this.name);

  @override
  _CheckLocationState createState() => _CheckLocationState();
}

class _CheckLocationState extends State<CheckLocation> {
  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: getMyLocation(),
            builder: (context, AsyncSnapshot<Position> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('empty page');
                  break;
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return Center(
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
                  );

                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    CameraPosition cameraPosition = CameraPosition(
                        target: LatLng(
                            snapshot.data.latitude, snapshot.data.longitude),
                        zoom: 12);
                    return Stack(
                      children: [
                        Row(),
                        PlacePicker(
                          apiKey: "AIzaSyAgT7WlFOpeuez5qKBL-yDXkuRpCUol0Rg",
                          onPlacePicked: (result) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Markets(
                                    widget.id,
                                    widget.name,
                                    result.geometry.location.lat,
                                    result.geometry.location.lng),
                              ),
                            );
                          },
                          usePlaceDetailSearch: true,
                          initialPosition: cameraPosition.target,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                        )
                      ],
                    );
                  }
                  break;
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocale.of(context).getTranslated("access"),
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text(
                          AppLocale.of(context).getTranslated("access_button"),
                          style: TextStyle(
                            color: CustomColors.whiteBG,
                          ),
                        ),
                        color: CustomColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Future<Position> getMyLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Position> setLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}

class Markets extends StatefulWidget {
  int id;
  String name;
  double latitude, longitude;

  Markets(this.id, this.name, this.latitude, this.longitude);

  @override
  _MarketsState createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  HomePageApi homePage;

  @override
  void initState() {
    homePage = HomePageApi();
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
      body: FutureBuilder(
          future: homePage.getSingleCategory(
              widget.id, widget.latitude, widget.longitude),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return emptyPage(context);
                break;
              case ConnectionState.waiting:
              case ConnectionState.active:
                return loading(context);
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

                        return _drawCardOfStore(
                          map,
                        );
                      },
                    ),
                  );
                } else
                  return emptyPage(context);
                break;
            }
            return emptyPage(context);
          }),
    );
  }

  Widget _drawCardOfStore(Map data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisplayMarket(),
          ));
        },
        child: Stack(
          children: <Widget>[
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: (data["photo"] == null)
                        ? Image.asset(
                            "assets/images/boxImage.png",
                          )
                        : Image(
                            loadingBuilder: (context, image,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) {
                                return image;
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            image: NetworkImage(data["photo"], scale: 1.0),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                data["name"],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .08,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "${AppLocale.of(context).getTranslated("delivery_time")}  ${data["shipping_time"]}  ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "${AppLocale.of(context).getTranslated("delivery_time")}  ${data["shipping_cost"]} ${AppLocale.of(context).getTranslated("delivery_cost_unit")} ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
