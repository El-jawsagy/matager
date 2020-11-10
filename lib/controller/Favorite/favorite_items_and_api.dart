import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMethodAPI {
  Future<int> addToFavorite(
    productId,
    storeId,
  ) async {
    String url = ApiPaths.addFavoriteItem;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    Map<String, dynamic> body = {
      "user_id": pref.get("UserId").toString(),
      "product_id": productId.toString(),
      "store_id": storeId.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<List> getFavoriteItems() async {
    print("i'm here get Items");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.favoriteUser(pref.get("UserId"));
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    var response = await http.get(url, headers: auth);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }

  Future<String> removeFavorite(
    favoriteId,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.removeFavoriteItem;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };

    Map<String, dynamic> body = {
      "id": favoriteId.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }
}
