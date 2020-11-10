import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';

class SearchProductsAndStoresApi {
  Future<List> getStores(string, id, lat, lng) async {
    String url = ApiPaths.searchStores(string, id, lat, lng);
    var response = await http.get(
      url,
    );
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var map = data['data'];
      return map;
    }
    return null;
  }

  Future<List> getProducts(string, id) async {
    String url = ApiPaths.searchProducts(string, id);
    var response = await http.get(
      url,
    );
    print(url);

    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var map = data['data'];
      return map;
    }
    return null;
  }


}
