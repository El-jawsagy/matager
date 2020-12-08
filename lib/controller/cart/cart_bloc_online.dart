import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:matager/view/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_items_bloc_and_Api.dart';

class CartItemsBlocOn {
  Map allItems = {
    'cart_items': [],
  };
  Map temp = {
    'cart_items': [],
  };
  CardMethodApi cardMethodApi = CardMethodApi();

  CartItemsBlocOn() {}

  /// The [cartOnlineStreamController] is an object of the StreamController class
  /// .broadcast enables the stream to be read in multiple screens of our app
  final cartOnlineStreamController = StreamController.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream get getStream => cartOnlineStreamController.stream;

  Function deepEq = const DeepCollectionEquality().equals;

  void setToCart() {
    restCart();

    SharedPreferences.getInstance().then((value) async {
      SharedPreferences pref = value;
      await cardMethodApi
          .getCartItems(pref.getString('token'), pref.get('UserId').toString())
          .then((value) {
        if (value != null) {
          for (var i in value) {
            print("value id $i");
            allItems['cart_items'].add(
              ({
                "data": i["product"],
                "quantity": double.tryParse(i['quantity']),
                "sub_store_id": i['store_id'],
                "new_price": double.tryParse(i['quantity']) *
                    double.tryParse(i['product']['price']),
                "cart_id": i["id"]
              }),
            );
          }
          cartOnlineStreamController.add(allItems);
        } else {
          this.allItems = {
            'cart_items': [],
          };
        }
      });
      var string = pref.getString("cart");
      print(string);
      if (string != null && string != "null") {
        print("i try now to get user");
      }
      countOfProducts.value = allItems['cart_items'].length;

      cartOnlineStreamController.add(allItems);
    });
  }

  void addToCart(item, quantity, id, price) {
    int index;
    int storeID = id;
    double fex;
    bool at = false;
    double newQuantity;
    if (allItems['cart_items'].length > 0) {
      var map = allItems['cart_items'];

      for (var i in map) {
        index = map.indexOf(i);
        print(item);
        print(i['data']);
        if (deepEq(i['data']['id'], item["id"])) {
          if (deepEq(i['data']['product_id'], item["product_id"])) {
            storeID = i['sub_store_id'];
            price = double.tryParse(i['data']["price"]);
            fex = i['quantity'];

            if (i['data']["unit"] == "0") {
              newQuantity = fex + quantity;
            } else {
              newQuantity = fex + quantity;
            }

            removeLocalFromCart(i);
            allItems['cart_items'].insert(
              index,
              ({
                "data": item,
                "quantity": newQuantity,
                "sub_store_id": storeID,
                "new_price": price * newQuantity
              }),
            );

            cardMethodApi
                .addToCart(item['id'], storeID, quantity, price)
                .then((value) {
              if (value == "true") {
                countOfProducts.value = allItems['cart_items'].length;
              }
            });
            at = true;
          }
        }
      }
    }
    if (!at) {
      print("now is now in cart and i add it");

      allItems['cart_items'].add({
        "data": item,
        "quantity": quantity,
        "sub_store_id": storeID,
        "new_price": price * quantity
      });
      cardMethodApi
          .addToCart(item['id'], storeID, quantity, price)
          .then((value) {
        if (value == "true") {
          getCounterProduct();
        }
      });
      SharedPreferences.getInstance().then((value) {
        SharedPreferences pref = value;
        var data = json.encode(allItems);

        pref.setString("cart", data);
      });
      cartOnlineStreamController.sink.add(allItems);
    }

    cartOnlineStreamController.sink.add(allItems);
  }

  void increaseQuantity(item, quantity) {
    double price, newQuantity;
    int storeID;
    int index;
    var fixed;
    if (allItems['cart_items'].length > 0) {
      var map = allItems['cart_items'];
      for (var i in map) {
        index = map.indexOf(i);
        if (deepEq(i['data']['id'], item["id"])) {
          if (deepEq(i['data']['product_id'], item["product_id"])) {
            print(i);
            storeID = i['sub_store_id'];
            price = double.tryParse(i['data']["price"]);

            if (i['data']["unit"] == "0") {
              fixed = 1;
              newQuantity = quantity + 1.0;
            } else {
              fixed = 0.25;

              newQuantity = quantity + 0.25;
            }

            removeLocalFromCart(i);
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
    }

    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(allItems);

      pref.setString("cart", data);
    });
    cardMethodApi.addToCart(item['id'], storeID, fixed, price);

    cartOnlineStreamController.sink.add(allItems);
  }

  void decreaseQuantity(item, quantity) {
    double price, newQuantity;
    int storeID;
    var fixed;
    int index;

    if (allItems['cart_items'].length > 0) {
      var map = allItems['cart_items'];

      for (var i in map) {
        index = map.indexOf(i);

        if (deepEq(i['data'], item)) {
          storeID = i['sub_store_id'];
          price = double.tryParse(i['data']["price"]);
          if (i['data']["unit"] == "0") {
            fixed = -1;

            newQuantity = quantity - 1.0;
          } else {
            fixed = -0.25;
            newQuantity = quantity - .25;
          }

          removeLocalFromCart(i);

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
    if ((quantity + fixed) > 0) {
      print(fixed);
      print(quantity + fixed);
      cardMethodApi.addToCart(item['id'], storeID, fixed, price);
    }

    cartOnlineStreamController.sink.add(allItems);
  }

  void removeLocalFromCart(item) {
    allItems['cart_items'].remove(item);
    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(allItems);
      pref.setString("cart", data);
    });
    cartOnlineStreamController.sink.add(allItems);
  }

  void removeFromCart(item) {
    allItems['cart_items'].remove(item);
    SharedPreferences.getInstance().then((value) async {
      SharedPreferences pref = value;

      await cardMethodApi
          .removeFromCart(
        pref.get('token'),
        pref.get("UserId"),
        item["data"]["id"],
        item["sub_store_id"],
      )
          .then((value) async {
        if (value == "true") {
          getCounterProduct();
          cartOnlineStreamController.add(this.allItems);
        }
      });
    });
    cartOnlineStreamController.sink.add(allItems);
  }

  void upgradeUserCart() {
    SharedPreferences.getInstance().then((value) async {
      SharedPreferences prefs = value;
      var data = await json.decode(prefs.getString("cart"));

      print(data);
      if (prefs.getString("cart") != null) {
        await cardMethodApi
            .removeCart(
          prefs.get('token'),
          prefs.get("UserId"),
        )
            .then((value) async {
          if (value == "true") {
            cardMethodApi.cartUpLoadAfterLogin(
              prefs.getString("cart"),
              prefs.getString('token'),
              prefs.get("UserId"),
            );
          }
          var data = await json.decode(prefs.getString("cart"));
          this.allItems = {
            'cart_items': data['cart_items'],
          };
          cartOnlineStreamController.add(this.allItems);
        });
      }
    });
  }

  void restCart() {
    allItems['cart_items'].clear();
    SharedPreferences.getInstance().then((value) {
      SharedPreferences pref = value;
      var data = json.encode(null);
      pref.setString("cart", data);
    });
    cartOnlineStreamController.sink.add(allItems);
  }

  /// The [dispose] method is used
  /// to automatically close the stream when the widget is removed from the widget tree
  void delete() {
    cartOnlineStreamController.close();
  }
}

CartItemsBlocOn itemBlocOnLine = CartItemsBlocOn();
