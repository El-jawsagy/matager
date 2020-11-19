import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';
import 'package:matager/view/user/cart/cart_online.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersApi {
  Future<String> makeOrder(
      List data, int addressId, couponId, couponDiscount) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.makeOrder;
    List stores_id = [];
    List sub_stores = [];

    List products = [];
    List quantities = [];
    List prices = [];

    if (data.length > 0) {
      for (var i in data) {
        if (!stores_id.contains(i["sub_store_id"])) {
          stores_id.add(i["sub_store_id"]);
        }

        products.add("${i["data"]["id"]}");
        quantities.add(i["quantity"]);
        prices.add(i["data"]["price"]);
        sub_stores.add(i["sub_store_id"]);
        // }

      }
      Map<String, dynamic> body = {};
      Map<String, String> auth = {
        'Authorization': "Bearer " + pref.get("token"),
      };
      if (couponId > 0) {
        body = {
          "user_id": pref.get("UserId").toString(),
          "stores_id": stores_id.toString(),
          "products": products.toString(),
          "quantities": quantities.toString(),
          "prices": prices.toString(),
          "sub_stores": sub_stores.toString(),
          "address_id": addressId.toString(),
          "coupon_id": couponId.toString(),
          "coupon_discount": couponDiscount.toString(),
        };
      } else {
        body = {
          "user_id": pref.get("UserId").toString(),
          "stores_id": stores_id.toString(),
          "products": products.toString(),
          "quantities": quantities.toString(),
          "prices": prices.toString(),
          "sub_stores": sub_stores.toString(),
          "address_id": addressId.toString(),
        };
      }

      var response = await http.post(url, body: body, headers: auth);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['data'] == "true") {
          itemBlocOnLineN.restCart();
        }
        return data['data'];
      }
    }
  }

  Future<List> getOrdersItems() async {
    print("i'm here get Items");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.getOrders(pref.get("UserId"));
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

  Future<String> makePharmaceOrder(storeId, message, image) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String url = ApiPaths.makePharmacyOrder;
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.getString("token"),
    };
    FormData formData;

    if (image != null) {
      String fileName = image.path.split('/').last;
      formData = FormData.fromMap(
        {
          'store_id': storeId,
          'user_id': pref.get("UserId"),
          'message': message,
          "image": await MultipartFile.fromFile(image.path, filename: fileName),
        },
      );
    } else {
      formData = FormData.fromMap(
        {
          'store_id': storeId,
          'user_id': pref.get("UserId"),
          'message': message,
        },
      );
    }
    print(formData.fields);
    var response =
        await Dio().post(url, data: formData, options: Options(headers: auth));
    print("i'm here get Items");

    if (response.statusCode == 200) {
      var data = response.data;
      return data["data"];
    }
  }

  Future<Map> rattingOrder(storeId, comment, stars) async {
    String url = ApiPaths.rattingAndCommentStore;
    SharedPreferences pref = await SharedPreferences.getInstance();

    Map<String, dynamic> body = {
      "user_id": pref.get("UserId").toString(),
      "store_id": storeId.toString(),
      "stars": stars.toString(),
      "comment": comment.toString(),
    };
    print("the body is $body");
    Map<String, String> auth = {
      'Authorization': "Bearer " + pref.get("token"),
    };
    var response = await http.post(url, body: body, headers: auth);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['data'] == "true") {
        itemBlocOnLineN.restCart();
      }
      return data;
    }
  }
}
