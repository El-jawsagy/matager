import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentMethodAPI {
  Future<int> addToComment(
    storeId,
    stars,
    comment,
  ) async {
    String url = ApiPaths.addStoreComment;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    Map<String, dynamic> body = {
      "user_id": pref.get("UserId").toString(),
      "stars": stars.toString(),
      "store_id": storeId.toString(),
      "comment": comment,
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<List> getFavoriteItems(storeId) async {
    print("i'm here get Items");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.storeComment(storeId);

    var response = await http.get(
      url,
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }
}
