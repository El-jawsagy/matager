import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matager/controller/address_api.dart';
import 'package:matager/utilities/lang/applocate.dart';
import 'package:matager/view/Authentication/login.dart';
import 'package:matager/view/user/address/setAddress.dart';
import 'package:matager/view/utilities/drawer.dart';
import 'package:matager/view/utilities/multi_screen.dart';
import 'package:matager/view/utilities/popular_widget.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/data/prefrences.dart';
import 'file:///C:/Users/mahmoud.ragab/projects/flutter_apps/matager/lib/utilities/theme/theme.dart';

import '../../homepage.dart';

class AddressScreen extends StatefulWidget {
  double latitude, longitude;

  AddressScreen(this.latitude, this.longitude);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

 final GlobalKey<ScaffoldState> addressscaffoldKey =
    new GlobalKey<ScaffoldState>();

class _AddressScreenState extends State<AddressScreen> {
  AddressAPI addressAPI = AddressAPI();
  ValueNotifier<int> _groupValue;
  ValueNotifier<int> _addressId;

  @override
  void initState() {
    _groupValue = ValueNotifier(0);
    _addressId = ValueNotifier(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DetectedScreen detectedScreen = DetectedScreen(context);
    AddressSize addressSize = AddressSize(detectedScreen);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: addressscaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocale.of(context).getTranslated("drawer_address"),
            style: TextStyle(
              color: CustomColors.whiteBG,
              fontSize: addressSize.headerTextSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        drawer: NavDrawer(widget.latitude, widget.longitude),
        body: FutureBuilder(
          future: Preference.getToken(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Column(
                      children: [
                        _drawTextAddress(
                            addressSize.headerTextSize, addressSize.iconSize),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .7,
                          child: FutureBuilder(
                              future: addressAPI.getUserAddress(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return emptyPage(context);
                                    break;
                                  case ConnectionState.waiting:

                                  case ConnectionState.active:
                                    return loading(context, 0.2);
                                    break;
                                  case ConnectionState.done:
                                    if (snapshot.hasData) {
                                      var data = snapshot.data;
                                      if (snapshot.data.length > 0) {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var item = data[index];
                                            if (item["default"] == 1) {
                                              _groupValue.value = index;
                                              _addressId.value = item["id"];
                                            }
                                            return _myRadioButton(
                                              title: item['full_address'],
                                              RadioButtonValue: index,
                                              onChanged: (newValue) {
                                                _groupValue.value = newValue;
                                                _addressId.value = item["id"];
                                              },
                                              posOfProducts: _groupValue,
                                              nameSize: addressSize.nameSize,
                                            );
                                          },
                                          itemCount: data.length,
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocale.of(context)
                                                    .getTranslated(
                                                        "Address_dis"),
                                                style: TextStyle(
                                                    fontSize:
                                                        addressSize.nameSize,
                                                    fontWeight: FontWeight.w600,
                                                    color: CustomColors.dark),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } else
                                      return emptyPage(context);
                                    break;
                                }
                                return emptyPage(context);
                              }),
                        ),
                        _drawAddOrRemoveAddress(
                            addressSize.nameSize, addressSize.iconSize),
                      ],
                    ),
                  ],
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                                      builder: (context) => LoginScreen(
                                          widget.latitude, widget.longitude)));
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
      ),
    );
  }

  Widget _drawTextAddress(double nameSize, iconSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .06,
            child: Center(
              child: Text(
                AppLocale.of(context).getTranslated("address_added"),
                style: TextStyle(
                    fontSize: nameSize,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primary),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .12,
            height: MediaQuery.of(context).size.height * .045,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomColors.primary,
                CustomColors.primary,
              ]),
              borderRadius: BorderRadius.circular(7),
            ),
            child: IconButton(
              icon: Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  size: iconSize,
                  color: CustomColors.whiteBG,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddAddressScreen(
                            widget.latitude, widget.longitude)));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _myRadioButton({
    String title,
    int RadioButtonValue,
    Function onChanged,
    ValueNotifier<int> posOfProducts,
    double nameSize,
  }) {
    return ValueListenableBuilder(
      valueListenable: posOfProducts,
      builder: (BuildContext context, value, Widget child) {
        return RadioListTile(
          value: RadioButtonValue,
          activeColor: CustomColors.primary,
          groupValue: posOfProducts.value,
          onChanged: onChanged,
          title: Text(
            title,
            style: TextStyle(
                fontSize: nameSize,
                fontWeight: FontWeight.w600,
                color: CustomColors.darkBlue),
          ),
        );
      },
    );
  }

  Widget _drawAddOrRemoveAddress(double nameSize, iconSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  addressAPI.setDefaultAddress(_addressId.value).then((value) {
                    setState(() {});
                  });
                },
                child: Text(
                  AppLocale.of(context).getTranslated("switch_address"),
                  style: TextStyle(
                    fontSize: nameSize,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.whiteBG,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .3,
            height: MediaQuery.of(context).size.height * .06,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomColors.gray,
                CustomColors.gray,
              ]),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.trash,
                  size: iconSize,
                  color: CustomColors.whiteBG,
                ),
                onPressed: () {
                  addressAPI.removeAddress(_addressId.value).then((value) {
                    setState(() {});
                  });
                },
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
