import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddressAPI {
  Future<List> getUserAddress() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.addressUser(pref.get("UserId"));

    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    var response = await http.get(url, headers: auth);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
  }

  Future<String> addAddress(fName, lName, phone, lPhone, city, region, street,
      building, floor, lat, lng) async {
    String url = ApiPaths.addAddress;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    Map<String, dynamic> body = {
      "user_id": pref.get("UserId").toString(),
      "fname": fName.toString(),
      "lname": lName.toString(),
      "phone": phone.toString(),
      "telephone": lPhone.toString(),
      "city": city.toString(),
      "region": region.toString(),
      "street": street.toString(),
      "building": building.toString(),
      "floor": floor.toString(),
      "lat": lat.toString(),
      "lng": lng.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<String> setDefaultAddress(
    addressId,
  ) async {
    String url = ApiPaths.setDefaultAddress;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    Map<String, dynamic> body = {
      "user_id": pref.get("UserId").toString(),
      "address_id": addressId.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<String> removeAddress(
    addressId,
  ) async {
    String url = ApiPaths.removeAddress;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    Map<String, dynamic> body = {
      "address_id": addressId.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }
}
