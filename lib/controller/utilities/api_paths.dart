class ApiPaths {
  static String mainDirection = "https://matagger.com/api";

  static String signUp = mainDirection + "/signup";
  static String login = mainDirection + "/login";
  static String getUser = mainDirection + "/user";

  static String updateProfile = mainDirection + "/updateprofile";

  static String singleCategoryStories(matgerId, lat, lng) =>
      mainDirection + "/stores?matger_id=$matgerId&lat=$lat&lng=$lng";

  static String singleStore(matgerId, userId) =>
      mainDirection + "/stores/$matgerId&user_id=$userId";

  static String storeSubCategory(matgerId, categoryId, userId) =>
      mainDirection +
      "/storecategory/subcategories/?store_id=$matgerId&category=$categoryId&user_id=$userId";

  static String storeSubCategoryProduct(matgerId, subcategoryId, userId) =>
      mainDirection +
      "/stores/subcategories/products?store_id=$matgerId&sub_category=$subcategoryId&user_id=$userId";
  static String allCategory = mainDirection + "/categories";

  static String storeComment(id) =>
      mainDirection + "/store-comments?store_id=$id";

  static String addStoreComment = mainDirection + "/add-comment";

  static String sliderImage = mainDirection + "/sliders";

  static String cartUser(id) => mainDirection + "/user-cart?user_id=$id";

  static String cartPriceUser(id) =>
      mainDirection + "/user-cart-total?user_id=$id";
  static String addToCartOff = mainDirection + "/add-cart-list";
  static String addToCartOn = mainDirection + "/add-to-cart";
  static String updateCart = mainDirection + "/update-cart-quantity";
  static String removeFromCart = mainDirection + "/remove-cart-list";

  static String singleProduct(productId) =>
      mainDirection + "/stores/product/$productId";

  static String getOrders(id) => mainDirection + "/user-orders?user_id=$id";
  static String makeOrder = mainDirection + "/makeorder";

  static String addressUser(id) =>
      mainDirection + "/user-addresses?user_id=$id";
  static String addAddress = mainDirection + "/add-address";
  static String setDefaultAddress = mainDirection + "/set-address-default";
  static String removeAddress = mainDirection + "/removeaddress";

  static String favoriteUser(id) =>
      mainDirection + "/user-favourite?user_id=$id";
  static String addFavoriteItem = mainDirection + "/add-to-fav";
  static String removeFavoriteItem = mainDirection + "/remove-favourite";

  static String aboutUs = mainDirection + "/about_us";
  static String termsOfUse = mainDirection + "/privacy_policy";
  static String contactUs = mainDirection + "/contact_us";

  static String searchProducts(string, id,) =>
      mainDirection + "/productsearch?store_id=$id&search=$string";

  static String searchStores(
      string, id, lat, lng
  ) =>
      mainDirection + "/stores?matger_id=$id&lat=$lat&lng=$lng&search=$string";
}
