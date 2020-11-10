// import 'dart:async';
// import 'dart:convert';
//
// import 'package:collection/collection.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'favorite_items_and_api.dart';
//
// //todo:you need to make favorite screen remove and add items in database of app
// class FavoriteItemsBlocOn {
//   Map allItems = {
//     'favorite_items': [],
//   };
//
//   FavoriteItemsBlocOn() {}
//
//   /// The [favoriteOnlineStreamController] is an object of the StreamController class
//   /// .broadcast enables the stream to be read in multiple screens of our app
//   final favoriteOnlineStreamController = StreamController.broadcast();
//
//   /// The [getStream] getter would be used to expose our stream to other classes
//   Stream get getStream => favoriteOnlineStreamController.stream;
//
//   Function deepEq = const DeepCollectionEquality().equals;
//
//   void setToFavorite() {
//     SharedPreferences.getInstance().then((value) async {
//       SharedPreferences pref = value;
//       var string = pref.getString("favorite");
//       print(string);
//       print("i try now to get user");
//
//       if (string != null && string != "null") {
//         print(pref.getString("favorite"));
//         var data = await json.decode(pref.getString("favorite"));
//
//         if (data != null) {
//           this.allItems = {
//             'favorite_items': data['favorite_items'],
//           };
//           favoriteOnlineStreamController.add(allItems);
//         }
//       } else if (string == null || string == "null") {
//         await favoriteMethodAPI
//             .getFavoriteItems(
//                 pref.getString('token'), pref.get('UserId').toString())
//             .then((value) {
//           if (value != null) {
//             for (var i in value) {
//               print("value id $i");
//               allItems['favorite_items'].add(
//                 ({
//                   "data": i["product"],
//                   "sub_store_id": i['store_id'],
//                   "favorite_id": i["id"]
//                 }),
//               );
//             }
//           } else {
//             this.allItems = {
//               'favorite_items': [],
//             };
//           }
//         });
//         var string = json.encode(allItems);
//         pref.setString("favorite", string);
//         favoriteOnlineStreamController.add(this.allItems);
//       }
//     });
//     favoriteOnlineStreamController.add(allItems);
//   }
//
//   void addToFavorite(item, store) {
//     print('here adding');
//
//     int storeID = store;
//
//     favoriteMethodAPI
//         .addToFavorite(
//       item['id'],
//       storeID,
//     )
//         .then((value) {
//       print('adding data');
//       print(value);
//       print(storeID);
//       print(item);
//       print('before add');
//       allItems['favorite_items'].add({
//         "data": item,
//         "sub_store_id": storeID,
//         "favorite_id": value,
//       });
//       print("this is all items ${allItems['favorite_items']}");
//       favoriteOnlineStreamController.sink.add(allItems);
//       print('after add');
//     });
//
//     SharedPreferences.getInstance().then((value) {
//       SharedPreferences pref = value;
//       var data = json.encode(allItems);
//
//       pref.setString("favorite", data);
//     });
//     favoriteOnlineStreamController.sink.add(allItems);
//   }
//
//
//   void restCart() {
//     allItems['favorite_items'].clear();
//     SharedPreferences.getInstance().then((value) {
//       SharedPreferences pref = value;
//       var data = json.encode(null);
//       pref.setString("favorite", data);
//     });
//     favoriteOnlineStreamController.sink.add(allItems);
//   }
//
//   /// The [dispose] method is used
//   /// to automatically close the stream when the widget is removed from the widget tree
//   void delete() {
//     favoriteOnlineStreamController.close();
//   }
// }
//
// FavoriteItemsBlocOn itemBlocOnLine = FavoriteItemsBlocOn();
