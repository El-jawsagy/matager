import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:matager/controller/address_api.dart';
import 'package:matager/lang/applocate.dart';
import 'package:matager/view/user/address/address.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../get_location.dart';

class AddAddressScreen extends StatefulWidget {
  double latitude, longitude;

  AddAddressScreen(this.latitude, this.longitude);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  double latitude, longitude;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String locationDetails, token;
  TextEditingController _fNameTextController;
  TextEditingController _lNameTextController;
  TextEditingController _phoneTextController;
  TextEditingController _lPhoneTextController;
  TextEditingController _cityTextController;
  TextEditingController _regionTextController;
  TextEditingController _streetTextController;
  TextEditingController _buildingTextController;
  TextEditingController _floorTextController;
  AddressAPI addressAPI = AddressAPI();

  @override
  void initState() {
    _fNameTextController = TextEditingController();
    _lNameTextController = TextEditingController();
    _phoneTextController = TextEditingController();
    _lPhoneTextController = TextEditingController();
    _cityTextController = TextEditingController();
    _regionTextController = TextEditingController();
    _streetTextController = TextEditingController();
    _buildingTextController = TextEditingController();
    _floorTextController = TextEditingController();

    SharedPreferences.getInstance().then((SharedPreferences value) {
      SharedPreferences prefs = value;

      latitude = prefs.getDouble("lat");
      longitude = prefs.getDouble("lng");
      print(latitude);
      print(longitude);
      token = prefs.getString("token");
      locationDetails = prefs.get("address");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          AppLocale.of(context).getTranslated("drawer_address"),
          style: TextStyle(
            color: CustomColors.whiteBG,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.05,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckLocation(1)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Text(
                        locationDetails,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: CustomColors.whiteBG,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FaIcon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: CustomColors.whiteBG,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: NavDrawer(widget.latitude, widget.longitude),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                _drawValidatorEditText(
                    AppLocale.of(context).getTranslated("first_name"),
                    AppLocale.of(context).getTranslated("wrong"),
                    18,
                    _fNameTextController),
                SizedBox(
                  height: 20,
                ),
                _drawEditText(
                    AppLocale.of(context).getTranslated("family_name"),
                    18,
                    _lNameTextController),
                SizedBox(
                  height: 20,
                ),
                _drawEditValidatorNumber(
                    AppLocale.of(context).getTranslated("phone"),
                    AppLocale.of(context).getTranslated("wrong"),
                    18,
                    _phoneTextController),
                SizedBox(
                  height: 20,
                ),
                _drawEditNumber(
                    AppLocale.of(context).getTranslated("ground_phone"),
                    AppLocale.of(context).getTranslated("wrong"),
                    18,
                    _lPhoneTextController),
                SizedBox(
                  height: 20,
                ),
                _drawValidatorEditText(
                    AppLocale.of(context).getTranslated("city"),
                    AppLocale.of(context).getTranslated("wrong"),
                    18,
                    _cityTextController),
                SizedBox(
                  height: 20,
                ),
                _drawValidatorEditText(
                    AppLocale.of(context).getTranslated("region"),
                    AppLocale.of(context).getTranslated("wrong"),
                    18,
                    _regionTextController),
                SizedBox(
                  height: 20,
                ),
                _drawValidatorEditText(
                    AppLocale.of(context).getTranslated("street"),
                    AppLocale.of(context).getTranslated("wrong"),
                    18,
                    _streetTextController),
                SizedBox(
                  height: 20,
                ),
                _drawValidatorEditText(
                    AppLocale.of(context).getTranslated("building"),
                    AppLocale.of(context).getTranslated("wrong"),
                    18,
                    _buildingTextController),
                SizedBox(
                  height: 20,
                ),
                _drawEditText(AppLocale.of(context).getTranslated("floor"), 18,
                    _floorTextController),
                SizedBox(
                  height: 20,
                ),
                _drawButtonAddAddress()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawEditText(
      String boxName, double titleTextSize, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      child: TextFormField(
        style: TextStyle(fontSize: titleTextSize),
        textAlign: TextAlign.left,
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        decoration: InputDecoration(
          labelText: boxName,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.primary,
              width: 0.75,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.gray,
              width: 0.75,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawValidatorEditText(String boxName, String validatorText,
      double titleTextSize, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      child: TextFormField(
        style: TextStyle(fontSize: titleTextSize),
        textAlign: TextAlign.left,
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        decoration: InputDecoration(
          labelText: boxName,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.primary,
              width: 0.75,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.gray,
              width: 0.75,
            ),
          ),
        ),
        validator: (onValue) {
          if (onValue.isEmpty) {
            return validatorText;
          }
          return null;
        },
      ),
    );
  }

  Widget _drawEditNumber(String boxName, String validatorText,
      double titleTextSize, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      child: TextFormField(
        style: TextStyle(fontSize: titleTextSize),
        textAlign: TextAlign.left,
        keyboardType: TextInputType.phone,
        controller: controller,
        decoration: InputDecoration(
          labelText: boxName,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.primary,
              width: 0.75,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.gray,
              width: 0.75,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawEditValidatorNumber(String boxName, String validatorText,
      double titleTextSize, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.89,
      child: TextFormField(
        style: TextStyle(fontSize: titleTextSize),
        textAlign: TextAlign.left,
        keyboardType: TextInputType.phone,
        controller: controller,
        decoration: InputDecoration(
          labelText: boxName,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.primary,
              width: 0.75,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide(
              color: CustomColors.gray,
              width: 0.75,
            ),
          ),
        ),
        validator: (onValue) {
          if (onValue.isEmpty) {
            return validatorText;
          }
          return null;
        },
      ),
    );
  }

  Widget _drawButtonAddAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(4),
            width: MediaQuery.of(context).size.width * .3,
            height: MediaQuery.of(context).size.height * .06,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomColors.primary,
                CustomColors.primary,
              ]),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    addressAPI
                        .addAddress(
                      _fNameTextController.text,
                      _lNameTextController.text,
                      _phoneTextController.text,
                      _lPhoneTextController.text,
                      _cityTextController.text,
                      _regionTextController.text,
                      _streetTextController.text,
                      _buildingTextController.text,
                      _floorTextController.text,
                      widget.latitude,
                      widget.longitude,
                    )
                        .then((value) {
                      if (value == "true") {
                        SnackBar mySnakBar = SnackBar(
                            content: Text(
                          'your address is add',
                          textAlign: TextAlign.center,
                        ));
                        _scaffoldKey.currentState.showSnackBar(mySnakBar);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddressScreen(
                                    widget.latitude, widget.longitude)));
                      }
                    });
                  }
                },
                child: Text(
                  AppLocale.of(context).getTranslated("add"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.whiteBG,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
