class ApiPaths {
  static String mainDirection = "https://matagger.com/api";

  static String signUp = mainDirection + "/signup";
  static String login = mainDirection + "/login";
  static String updateProfile = mainDirection + "/updateprofile";

  static String singleCategoryStories(matgerId, lat, lng) =>
      mainDirection + "/stores?matger_id=$matgerId&lat=$lat&lng=$lng";

  static String singleStore(matgerId) => mainDirection + "/stores/$matgerId";

  static String storeSubCategory(matgerId, categoryId) =>
      mainDirection +
      "/storecategory/subcategories/?store_id=$matgerId&category=$categoryId";

  static String storeSubCategoryProduct(matgerId, subcategoryId) =>
      mainDirection +
      "/stores/subcategories/products?store_id=$matgerId&sub_category=$subcategoryId";
  static String allCategory = mainDirection + "/categories";

  static String sliderImage = mainDirection + "/sliders";

  static String cartUser(id) => mainDirection + "/user-cart?user_id=$id";

  static String cartPriceUser(id) =>
      mainDirection + "/user-cart-total?user_id=$id";

  static String addToCartOff = mainDirection + "/add-cart-list";
  static String addToCartOn = mainDirection + "/add-to-cart";
  static String updateCart = mainDirection + "/update-cart-quantity";
  static String removeFromCart = mainDirection + "/remove-cart-list";

  static String makeOrder = mainDirection + "/makeorder";

  static String addressUser(id) =>
      mainDirection + "/user-addresses?user_id=$id";
  static String addAddress = mainDirection + "/add-address";
  static String setDefaultAddress = mainDirection + "/set-address-default";
  static String removeAddress = mainDirection + "/removeaddress";
}
