import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:matager/view/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItemsBlocOff {
  Map allItems = {
    'cart_items': [],
  };

  CartItemsBlocOff() {
    SharedPreferences.getInstance().then((value) async {
      SharedPreferences pref = value;
      var data = await json.decode(pref.getString("cart"));
      if (data != null || data != "null") {
        this.allItems = {
          'cart_items': data['cart_items'],
        };
        cartOffLineStreamController.add(allItems);
      } else {
        this.allItems = {
          'cart_items': [],
        };
        cartOffLineStreamController.add(allItems);
      }
    });
  }

  /// The [cartOffLineStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartOffLineStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => cartOffLineStreamController.stream;
  Function deepEq = const DeepCollectionEquality().equals;

  void addToCart(item, quantity, id, price) {
    int index;

    int storeID = id;
    double fex;

    bool at = false;
    double newQuantity;
    if (allItems['cart_items'].length > 0) {
      var map = allItems['cart_items'];

      for (var i in map) {
        if (deepEq(i['data'], item)) {
          index = map.indexOf(i);

          fex = i['quantity'];
          if (i['data']["unit"] == "0") {
            newQuantity = fex + quantity;
          } else {
            newQuantity = fex + quantity;
          }
          removeFromCart(i);
          allItems['cart_items'].insert(
            index,
            ({
              "data": item,
              "quantity": newQuantity,
              "sub_store_id": storeID,
              "new_price": price * newQuantity
            }),
          );
          at = true;
        }
      }
    }
    if (!at) {
      if (item["unit"] == "0") {
        newQuantity = quantity;
      } else {
        newQuantity = quantity;
      }

      allItems['cart_items'].add({
        "data": item,
        "quantity": newQuantity,
        "sub_store_id": storeID,
        "new_price": price * newQuantity
      });
    }
    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(allItems);

      pref.setString("cart", data);
    });
    countOfProducts.value = allItems['cart_items'].length;
    cartOffLineStreamController.sink.add(allItems);
  }

  void increaseQuantity(item, quantity) {
    double price, newQuantity;
    int storeID;
    int index;

    if (allItems['cart_items'].length > 0) {
      var map = allItems['cart_items'];
      for (var i in map) {
        index = map.indexOf(i);

        if (deepEq(i['data'], item)) {
          storeID = i['sub_store_id'];
          price = double.tryParse(i['data']["price"]);

          if (i['data']["unit"] == "0") {
            newQuantity = quantity + 1.0;
          } else {
            newQuantity = quantity + 0.25;
          }

          removeFromCart(i);
          allItems['cart_items'].insert(
            index,
            ({
              "data": item,
              "quantity": newQuantity,
              "sub_store_id": storeID,
              "new_price": price * newQuantity
            }),
          );
        }
      }
    }

    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(allItems);

      pref.setString("cart", data);
    });
    cartOffLineStreamController.sink.add(allItems);
  }

  void decreaseQuantity(item, quantity) {
    double price, newQuantity;
    int storeID;
    int index;

    if (allItems['cart_items'].length > 0) {
      var map = allItems['cart_items'];

      for (var i in map) {
        index = map.indexOf(i);

        if (deepEq(i['data'], item)) {
          storeID = i['sub_store_id'];
          price = double.tryParse(i['data']["price"]);
          if (i['data']["unit"] == "0") {
            newQuantity = quantity - 1.0;
          } else {
            newQuantity = quantity - .25;
          }

          removeFromCart(i);
          allItems['cart_items'].insert(
            index,
            ({
              "data": item,
              "quantity": newQuantity,
              "sub_store_id": storeID,
              "new_price": price * newQuantity
            }),
          );
        }
      }
    }

    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(allItems);

      pref.setString("cart", data);
    });
    cartOffLineStreamController.sink.add(allItems);
  }

  void removeFromCart(item) {
    allItems['cart_items'].remove(item);
    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(allItems);
      pref.setString("cart", data);
    });
    countOfProducts.value = allItems['cart_items'].length;
    cartOffLineStreamController.sink.add(allItems);
  }

  void restCart() {
    allItems['cart_items'].clear();
    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(null);
      pref.setString("cart", data);
    });
    cartOffLineStreamController.sink.add(allItems);
  }

  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void dispose() {
    cartOffLineStreamController.close(); //
  }
}

final itemBlocOffLine = CartItemsBlocOff();
