import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matager/view/utilities/api_paths.dart';

class HomePageApi {
  Future<List> getAllCategory() async {
    String url = ApiPaths.allCategory;
    var response = await http.get(
      url,
    );
    print("done");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'
          ''];
    }
    return null;
  }

  Future<List> getSingleCategory(matger_id, lat, lng) async {
    String url = ApiPaths.singleCategoryStories(matger_id, lat, lng);
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }
}
