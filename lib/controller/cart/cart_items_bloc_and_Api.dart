import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_bloc_off.dart';

class CardMethodApi {
  Future<String> cartUpLoadBeforLogin(string, token, id) async {
    String url = ApiPaths.addToCartOff;

    Map<String, dynamic> postBody = {'cart': string, 'user_id': id.toString()};

    Map<String, String> auth = {
      'Authorization': "Bearer " + token,
    };

    var response = await http.post(url, body: postBody, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['data'] == "true") {
        var all = json.decode(string);
        for (var i in all['cart_items']) {
          itemBlocOffLine.restCart();
        }
      }
    }
  }

  Future<String> cartUpLoadAfterLogin(string, token, id) async {
    String url = ApiPaths.addToCartOff;
    Map<String, dynamic> postBody = {'cart': string, 'user_id': id.toString()};

    Map<String, String> auth = {
      'Authorization': "Bearer " + token,
    };

    var response = await http.post(url, body: postBody, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
  }

  Future<String> addToCart(productId, storeId, quantity, price) async {
    String url = ApiPaths.addToCartOn;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    Map<String, dynamic> body = {
      "user_id": pref.get("UserId").toString(),
      "product_id": productId.toString(),
      "store_id": storeId.toString(),
      "quantity": quantity.toString(),
      "price": price.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<List> getCartItems(token, id) async {
    print("i'm here get Items");
    String url = ApiPaths.cartUser(id);
    Map<String, String> auth = {
      'Authorization': "Bearer " + token,
    };

    var response = await http.get(url, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }

  Future<String> removeCart(
    token,
    cartId,
  ) async {
    String url = ApiPaths.removeCart;
    Map<String, String> auth = {
      'Authorization': "Bearer " + token,
    };

    Map<String, dynamic> body = {
      "user_id": cartId.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<String> removeFromCart(token, userId, productId, StoreId) async {
    String url = ApiPaths.removeFromCart;
    Map<String, String> auth = {
      'Authorization': "Bearer " + token,
    };

    Map<String, dynamic> body = {
      "user_id": userId.toString(),
      "product_id": productId.toString(),
      "store_id": StoreId.toString(),
    };
    var response = await http.post(url, body: body, headers: auth);
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
    return null;
  }

  Future<Map> getCartPrice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = ApiPaths.cartPriceUser(pref.get("UserId"));
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };

    var response = await http.get(url, headers: auth);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"];
    }
  }

  Future<Map> checkCoupon(string) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = ApiPaths.checkCoupon;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };
    Map<String, dynamic> body = {
      'user_id': pref.get("UserId").toString(),
      'coupon': string,
    };

    var response = await http.post(url, body: body, headers: auth);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    }
  }


}
Future<int> getCount() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  String url = ApiPaths.getCartCount(pref.get("UserId"));
  Map<String, String> auth = {
    'Authorization': "Bearer " + pref.get("token"),
  };

  var response = await http.get(url, headers: auth);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data["data"];
  }
}