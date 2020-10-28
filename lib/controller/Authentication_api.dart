import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matager/view/utilities/api_paths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  Future<String> login(email, password) async {
    String url = ApiPaths.login;
    Map<String, dynamic> postBody = {
      'email': email,
      'password': password,
    };
    var response = await http.post(url, body: postBody);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(response.body);

      switch (data['data']) {
        case "email wrong":
        case "password wrong":
          return data['data'];
          break;

        default:
          print("this is value of login ${data['data']}");
          if (data['data']['token'].length > 50) {
            setToken(data['data']['token']);
            setEmail(email);
            setName(data['data']['name']);
            setPhoto(data['data']['image']);
            setId(data['data']["id"]);
          }
          return data['data']['token'];

          break;
      }
    }
  }

  Future signUp(name, lastName, phone, email, password) async {
    String url = ApiPaths.signUp;

    Map<String, dynamic> postBody = {
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'password': password,
    };
    var response = await http.post(url, body: postBody);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['data'].length > 50) {
        setToken(data['data']["token"]);
        setEmail(email);
        setName(name + '' + lastName);
      }

      return data['data'];
    }
  }
}

setLanguage(bool language) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('language', language);
}

setToken(String token) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  print("token is change");
  await preferences.setString("token", token);
}

setId(int id) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  print("name is change");
  await preferences.setInt("UserId", id);
}

setEmail(String email) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  print("email is change");
  await preferences.setString("email", email);
}

setName(String name) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  print("name is change");
  await preferences.setString("name", name);
}

setPhoto(String image) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  print("photo is change");
  await preferences.setString("photo", image);
}
