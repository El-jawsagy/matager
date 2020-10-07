import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/homepage.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckLocation extends StatefulWidget {
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
                          onPlacePicked: (result) async {
                            saveLocation(result.formattedAddress);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                    result.geometry.location.lat,
                                    result.geometry.location.lng,
                                    result.formattedAddress),
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

saveLocation(String add) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  print("location is change");
  await preferences.setString("address", add);
}
