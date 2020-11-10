import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:matager/controller/utilities/api_paths.dart';
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
            setEmail(email);
            setName(data['data']['name']);
            setPhoto(data['data']['image']);
            setId(data['data']["id"]);
            setToken(data['data']['token']);
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

  Future<String> updateUser(
    id,
    name,
    lastname,
    email,
    phone,
    oldPassword,
    newPassword,
    token,
    File image,
  ) async {
    String url = ApiPaths.updateProfile;
    FormData formData;
    Map<String, String> auth = {
      'Authorization': "Bearer " + token,
    };
    if (image != null) {
      String fileName = image.path.split('/').last;
      formData = FormData.fromMap(
        {
          'user_id': id,
          'email': email,
          'new_password': newPassword,
          'old_password': oldPassword,
          'phone': phone,
          'name': name,
          'lastname': lastname,
          "image": await MultipartFile.fromFile(image.path, filename: fileName),
        },
      );
    } else {
      formData = FormData.fromMap(
        {
          'user_id': id,
          'email': email,
          'new_password': newPassword,
          'old_password': oldPassword,
          'phone': phone,
          'name': name,
          'lastname': lastname,
        },
      );
    }
    print(formData.fields);
    var response =
        await Dio().post(url, data: formData, options: Options(headers: auth));
    print(response.data);
    if (response.statusCode == 200) {
      var data = response.data;
      switch (data['data']) {
        case "email exist":
          return "email exist";
          break;
        case "phone exist":
          return "phone exist";
          break;
        case "old password wrong":
          return "old password wrong";
          break;
        case "user not exist":
          return "user not exist";
          break;
        default:
          setEmail(email);
          setName(data['data']['name']);
          setPhoto(data['data']['image']);
          return "true";
          break;
      }
    }
  }

  Future<Map> getUser(token) async {
    String url = ApiPaths.getUser;
    Map<String, String> auth = {
      'Authorization': "Bearer " + token,
    };

    var response = await http.get(url, headers: auth);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

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
