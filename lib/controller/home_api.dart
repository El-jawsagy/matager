import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matager/view/utilities/api_paths.dart';

class MarketAndCategoryApi {

  Future<List> getSliderImages() async {
    String url = ApiPaths.sliderImage;
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<List> getAllCategory() async {
    String url = ApiPaths.allCategory;
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<List> getSingleCategory(matgerId, lat, lng) async {
    String url = ApiPaths.singleCategoryStories(matgerId, lat, lng);
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<Map> getSingleMarket(matgerId) async {
    String url = ApiPaths.singleStore(matgerId);
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<List> getSingleMarketSubcategory(matgerId, categoryId) async {
    String url = ApiPaths.storeSubCategory(matgerId, categoryId);
    var response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data'];
    }
    return null;
  }

  Future<List> getSingleMarketCategoryProducts(matgerId, categoryId) async {
    String url = ApiPaths.storeSubCategoryProduct(matgerId, categoryId);
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

class ProductBloc {
  List products;

  int categoryId, storeId;

  final StreamController<List> _productsController =
      StreamController<List>.broadcast();

  final StreamController<int> _categoryController = StreamController<int>();

  Stream<List> get productStream => _productsController.stream;

  StreamSink<int> get categoryIdSink => _categoryController.sink;

  Stream<int> get categoryIdStream => _categoryController.stream;
  MarketAndCategoryApi marketAndCategoryApi = MarketAndCategoryApi();

  ProductBloc(storeId) {
    this.storeId = storeId;
    products = [];
    _productsController.add(this.products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchProductsFromApi);
  }

  Future<void> _fetchProductsFromApi(int categoryId) async {
    this.products = await marketAndCategoryApi.getSingleMarketCategoryProducts(
        storeId, categoryId);
    _productsController.add(this.products);
  }

  void dispose() {
    _productsController.close();
    _categoryController.close();
  }
}
