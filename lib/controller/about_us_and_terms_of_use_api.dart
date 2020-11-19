import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';

class AboutAndTermsOfUseAPI {
  Future<Map> getInformationAboutUs(lang) async {
    String url = ApiPaths.aboutUs(lang);
    var response = await http.get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var map = data['data'];
      return map;
    }
    return null;
  }

  Future<Map> getTermsOfUse(lang) async {
    String url = ApiPaths.termsOfUse(lang);
    var response = await http.get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var map = data['data'];
      return map;
    }
    return null;
  }

  Future<String> sendContactUs(name, phone, message, title, email) async {
    String url = ApiPaths.contactUs;
    Map<String, dynamic> body = {
      'name': name,
      'phone': phone,
      'message': message,
      'title': title,
      'email': email,
    };
    print(body);
    var response = await http.post(url, body: body);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var map = data['data'];
      return map;
    }
    return null;
  }
}
